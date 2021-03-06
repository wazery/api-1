class NotesController < BaseController
  before_action :set_note, only: %i(show update destroy)

  ################# Documentation ##############################################
  api :GET, '/projects/:project_id/artboards/:artboard_id/notes', 'Returns all notes for the artboard'
  example <<-EOS
    [
      {
        id:
        note:
        rect: {
          x:
          y:
        }
      }
    ]
  EOS
  param :artboard_id, Integer, desc: 'Artboard ID', required: true
  error code: 401, desc: 'Authentication failed'
  error code: 404, desc: 'Artboard not found'
  ################# /Documentation #############################################
  def index
    @notes = Artboard.find(params[:artboard_id]).notes

    render json: @notes.decorate.to_json
  end

  ################# Documentation ##############################################
  api :GET, '/projects/:project_id/artboards/:artboard_id/notes/:id', 'Returns the requested notes or the errors'
  example <<-EOS
    {
      id:
      note:
      rect: {
        x:
        y:
      }
    }
  EOS
  param :artboard_id, Integer, desc: 'Artboard ID', required: true
  error code: 400, desc: 'Bad request, when empty project hash is passed'
  error code: 401, desc: 'Authentication failed'
  error code: 404, desc: 'Project not found'
  ################# /Documentation #############################################
  def show
    render json: @note.decorate.to_json
  end

  ################# Documentation ##############################################
  api :POST, '/projects/:project_id/artboards/:artboard_id/notes', 'Returns the created notes or the errors'
  example <<-EOS
    {
      id:
      note:
      rect: {
        x:
        y:
      }
    }
  EOS
  param :artboard_id, Integer, desc: 'Artboard ID', required: true
  param :note, Hash, required: true do
    param :note, String, desc: 'Tag name', required: true
    param :rect, Hash, desc: 'Tag name', required: true do
      param :x, Integer, desc: 'X position', required: true
      param :y, Integer, desc: 'X position', required: true
    end
  end
  error code: 400, desc: 'Bad request, when empty note hash is passed'
  error code: 401, desc: 'Authentication failed'
  ################# /Documentation #############################################
  def create
    @note = Note.new(note_params)

    if @note.save
      render json: @note.decorate.to_json, status: :created
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  ################# Documentation ##############################################
  api :PUT, '/projects/:project_id/artboards/:artboard_id/notes', 'Returns the updated notes or the errors'
  example <<-EOS
    {
      id:
      note:
      rect: {
        x:
        y:
      }
    }
  EOS
  param :artboard_id, Integer, desc: 'Artboard ID', required: true
  param :note, Hash, required: true do
    param :note, String, desc: 'Tag name', required: true
    param :rect, Hash, desc: 'Tag name', required: true do
      param :x, Integer, desc: 'X position', required: true
      param :y, Integer, desc: 'X position', required: true
    end
  end
  error code: 400, desc: 'Bad request, when empty note hash is passed'
  error code: 401, desc: 'Authentication failed'
  ################# /Documentation #############################################
  def update
    if @note.update(note_params)
      render json: @note.decorate.to_json
    else
      render json: @note.errors, status: :unprocessable_entity
    end
  end

  ################# Documentation ##############################################
  api :DELETE, '/projects/:project_id/artboards/:artboard_id/notes/:id', 'Does not return anything'
  error code: 401, desc: 'Authentication failed'
  ################# /Documentation #############################################
  def destroy
    @note.destroy
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_note
      @note = Note.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def note_params
      params.require(:note).permit(:note, :artboard_id, :user_id, rect: [:x, :y, :width, :height])
    end
end
