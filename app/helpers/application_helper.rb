module ApplicationHelper
  def full_title(page_title)
    base_title = 'ChickTech'
    if page_title.empty?
      base_title
    else
      "#{base_title} | #{page_title}"
    end
  end

  def position_display(position)
  	content_tag :span, class: 'position-display' do
	  	if position.user.nil?
	  	  sign_up_link(position)
	  	elsif position.user = current_user
	  		("You " + resignation_link(position)).html_safe
	  	else 
	  		position.user.full_name
	  	end
	  end
  end

  def sign_up_link(position)
  	position_path = position.class.name.underscore + "_path"
  	button_to "Take the Lead!", send(position_path, position, signing_up: true), method: :patch, :class => 'btn btn-xs btn-success'
  end

  def resignation_link(position)
  	position_path = position.class.name.underscore + "_path"
  	link_to "(resign)", send(position_path, position, resigning: true), method: :patch, class: 'text-muted'
  end
end
