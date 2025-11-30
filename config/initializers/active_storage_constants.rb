# Define globally accessible constants related to Active Storage.
# This avoids "already initialized constant" warnings by ensuring
# the constant is defined only once when the application starts.

# Accepted content types for image uploads (e.g., for avatars).
# Used in Active Storage content_type validations.
ACCEPTED_IMAGE_TYPES = %w[image/png image/jpeg].freeze
