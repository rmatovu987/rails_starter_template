class System::PermissionNodesController < ApplicationController
  before_action :set_system_permission_node, only: %i[ show edit update destroy ]

  # GET /settings/system/permission_nodes or /settings/system/permission_nodes.json
  def index
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::VIEW_ALL
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "System", url: nil },
      { name: "Permission Nodes", url: system_permission_nodes_path }
    ]
    @system_permission_nodes = System::PermissionNode.roots.includes(children: :children)
  end

  # GET /settings/system/permission_nodes/1 or /settings/system/permission_nodes/1.json
  def show
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::VIEW_DETAILS
    @breadcrumbs = [
      { name: "Home", url: root_path },
      { name: "Settings", url: nil },
      { name: "System", url: nil },
      { name: "Permission Nodes", url: system_permission_nodes_path },
      { name: @system_permission_node.name, url: system_permission_node_path(@system_permission_node) }
    ]
    @versions = dependent_versions(@system_permission_node)
  end

  # GET /settings/system/permission_nodes/new
  def new
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::CREATE
    @system_permission_node = System::PermissionNode.new
  end

  # GET /settings/system/permission_nodes/1/edit
  def edit
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::UPDATE
  end

  # POST /settings/system/permission_nodes or /settings/system/permission_nodes.json
  def create
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::CREATE
    @system_permission_node = System::PermissionNode.new(system_permission_node_params)

    respond_to do |format|
      if @system_permission_node.save
        format.html { redirect_to @system_permission_node, notice: "Permission node was successfully created." }
        format.json { render :show, status: :created, location: @system_permission_node }
      else
        format.html { render :new, status: :unprocessable_content }
        format.json { render json: @system_permission_node.errors, status: :unprocessable_content }
      end
    end
  end

  # PATCH/PUT /settings/system/permission_nodes/1 or /settings/system/permission_nodes/1.json
  def update
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::UPDATE
    respond_to do |format|
      if @system_permission_node.update(system_permission_node_params)
        format.html { redirect_to @system_permission_node, notice: "Permission node was successfully updated." }
        format.json { render :show, status: :ok, location: @system_permission_node }
      else
        format.html { render :edit, status: :unprocessable_content }
        format.json { render json: @system_permission_node.errors, status: :unprocessable_content }
      end
    end
  end

  # DELETE /settings/system/permission_nodes/1 or /settings/system/permission_nodes/1.json
  def destroy
    authorize! NodeNames::PERMISSION_NODES, PermissionNames::DELETE
    @system_permission_node.destroy!

    respond_to do |format|
      format.html { redirect_to system_permission_nodes_path, status: :see_other, notice: "Permission node was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_system_permission_node
      @system_permission_node = System::PermissionNode.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def system_permission_node_params
      params.expect(system_permission_node: [ :business_id, :parent_id, :path, :name, :unique_id, :encoded_key ])
    end
end
