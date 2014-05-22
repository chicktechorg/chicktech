class Template < Event
  default_scope { where(template: true) }
end

