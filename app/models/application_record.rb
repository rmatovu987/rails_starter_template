class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class
  after_create_commit :create_encoded_key
  after_save_commit :generate_unique_id, if: :unique_id_needed?

  include ObfuscatesId
  include PgSearch::Model

  ##
  # Creates a unique encoded key for the record after creation.
  #
  # @return [void]
  def create_encoded_key
    return unless encoded_key.nil? || encoded_key == ""

    uuid = SecureRandom.uuid
    self.encoded_key = uuid.delete("-")
    save
  end

  ##
  # Generates a unique_id for the record after saving,
  # only if the model supports it.
  #
  # @return [void]
  def generate_unique_id
    return unless unique_id_needed?
    return if unique_id.present?

    self.unique_id = self.class.encode_id(self.id)
    save
  end

  ##
  # Finds a record by:
  # - Database ID (numeric)
  # - Encoded ID (obfuscated form)
  # - Unique ID (business identifier)
  #
  # After fetching, enforces branch-level authorization if the record
  # has a `branch_id` column.
  #
  # @param id [Integer, String] The identifier of the record
  # @return [ApplicationRecord] The located record
  # @raise [ActiveRecord::RecordNotFound] If no record matches the given id
  # @raise [BranchAccessError] If the record exists but is outside the
  #   current user's authorized branches
  def self.find(id)
    # Use `unscoped` to bypass the default_scope just for this initial lookup.
    record = unscoped do
      if id.to_s.match?(/\A\d+\z/) # numeric ID
        super(id)
      elsif id.to_s.match?(/\A[a-zA-Z]+\z/) # encoded ID
        super(decode_id(id))
      else
        # `find_by!` is also affected by default_scope
        find_by(unique_id: id)
      end
    end

    record
  end

  private

  ##
  # Determines if a model requires a unique_id to be generated.
  #
  # @return [Boolean] true if the model responds to both
  #   `business_id` and `unique_id`, false otherwise
  def unique_id_needed?
    respond_to?(:business_id) && respond_to?(:unique_id)
  end
end
