# class Api::V1::TemplatesController < ApplicationController
# end
class Api::V1::TemplatesController < ApplicationController
  before_action :set_template, only: [:show, :update, :destroy]


  def index
    @templates_all = Template.all
    render json: @templates_all
  end

  # POST /api/v1/templates
  def create
    template = Template.new(template_params)
    if template.save
      render json: { message: "Template created successfully", template: template }, status: :created
    else
      render json: { errors: template.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # GET /api/v1/templates/:id
  def show
    render json: @template
  end

  # PUT /api/v1/templates/:id
  def update
    if @template.update(template_params)
      render json: { message: "Template updated successfully", template: @template }
    else
      render json: { errors: @template.errors.full_messages }, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/templates/:id
  def destroy
    if @template.destroy
      render json: { message: "Template deleted successfully" }
    else
      render json: { errors: "Failed to delete template" }, status: :unprocessable_entity
    end
  end

  private

  def set_template
    @template = Template.find(params[:id])
  end

  def template_params
    params.require(:template).permit(:name, :subject, :body)
  end
end
