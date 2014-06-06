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
  	tag_class = position.class.name == "Job" ? "job_user" : "team_leader"
  	content_tag :span, class: tag_class do
	  	if position.user.nil?
	  	  sign_up_button(position)
	  	elsif position.user == current_user
	  		("You " + resignation_link(position)).html_safe
	  	else 
	  		link_to position.user.full_name, position.user
	  	end
	  end
  end

  def sign_up_button(position)
  	position_path = position.class.name.underscore + "_path"
  	link_to "Sign up", send(position_path, position, signing_up: true), method: :patch, class: 'sign_up'
  end

  def resignation_link(position)
  	position_path = position.class.name.underscore + "_path"
  	link_to "(resign)", send(position_path, position, resigning: true), method: :patch, class: 'resign'
  end

  def event_date_range(event)
		format = "%A, %B %-d at %-l:%M%P"
		start = event.start.strftime(format)
		finish = event.finish.strftime(format)
		"#{start} - #{finish}"
  end
end
