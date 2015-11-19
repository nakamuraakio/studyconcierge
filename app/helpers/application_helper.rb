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

  def form_for_report(condition, &block)
    if condition
        form_for @report, :url => {controller: 'reports', action: 'create'}, &block
    else
        form_for @report, :url => {controller: 'reports', action: 'update_via_timer', id: @report.id}, &block
    end
  end

  def subject_hash
    return {
      "japanese" => "現代文",
      "old_japanese" => "古文",
      "old_chinese" => "漢文",
      "english" => "英語",
      "math" => "数学",
      "physics" => "物理",
      "chemistry" => "化学",
      "biology" => "生物",
      "geology" => "地学",
      "world_history" => "世界史",
      "japanese_history" => "日本史",
      "politics_and_economics" => "政治経済",
      "modern_society" => "現代社会",
      "ethics" => "倫理",
      "geography" => "地理",
    }
  end
end
