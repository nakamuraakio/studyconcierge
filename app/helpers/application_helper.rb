module ApplicationHelper
  def active_if_current(current_path)
    if current_page?(current_path)
      return 'active'
    else
      return ''
    end
  end

  def block_is_haml?(block)
      eval('!!defined?(_hamlout)', block.binding)
    end
end
