class Template < Event
  default_scope { where(template: true) }

  def new(event_hash)
    binding.pry
    return event
  end

# Template.create(some_event)

# before_save { @template = true }

# def create(event)
#   template = event.dup
#   # nullify city, start, end
# end

# event.create_template

# def create_template
#   template = self.dup(...)
#   template.
# end

# my_new_template = Template.new(event, {name: "Template name"})

# class event_template < event
#   def event_from_template(template)
#     project = template.dup
#     project.type = 'Project'
#     project
#   end
# end
end

