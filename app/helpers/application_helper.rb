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
  	tag_class = position.class.name == "Job" ? "volunteer" : "leader"
  	content_tag :span, class: tag_class do
	  	if position.user.nil?
	  	  sign_up_button(position)
	  	elsif position.user == current_user
	  		("You " + resignation_link(position)).html_safe
	  	else 
	  		link_to(position.user.full_name, position.user) + ' ' + remove_volunteer_link(position)
	  	end
	  end
  end

  def event_leader_display(event_leadership_role)
    if cannot? :update, event_leadership_role.leadable
      button_to 'I Would Like To Lead This Event', emails_path(:event_id => event_leadership_role.leadable.id), :class => "btn btn-warning btn-xs"
    else
      position_display(event_leadership_role)
    end
  end

  def sign_up_button(position)
  	position_path = position.class.name.underscore + "_path"
  	link_to "Sign up", send(position_path, position, signing_up: true), method: :patch, class: 'sign_up'
  end

  def resignation_link(position)
    link_text = current_user ? "resign" : "unassign"
  	position_path = position.class.name.underscore + "_path"
  	link_to "(#{link_text})", send(position_path, position, resigning: true), method: :patch, class: 'resign'
  end

  def remove_volunteer_link(position)
    if can? :update, position
      position_path = position.class.name.underscore + "_path"
      link_to "(unassign)", send(position_path, position, resigning: true), method: :patch, class: 'resign'
    end
  end

  def event_date_range(event)
		format = "%A, %B %-d at %-l:%M%P"
		start = event.start.strftime(format)
		finish = event.finish.strftime(format)
		"#{start} - #{finish}"
  end
end
