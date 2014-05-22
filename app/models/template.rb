class Template < Event
  default_scope { where(template: true) }

  def create_event_from_template
    event = self.dup :validate => false, :include => [{:jobs => :tasks}, {:teams => {:jobs => :tasks}}]
    event.update(template: false)
    event
  end
end

