class ProjectDecorator < Draper::Decorator
  delegate_all

  def to_json
    ret             = as_json(except: %i(created_at updated_at))
    ret[:artboards] = artboards.decorate.to_json
    ret[:slices]    = slices # FIXME: Needs to be moved to artboards
    ret[:colors]    = colors

    ret
  end

  def to_index_json
    ret = as_json(except: %i(updated_at slices colors))

    ret[:members] = members.decorate.to_json

    ret
  end
end