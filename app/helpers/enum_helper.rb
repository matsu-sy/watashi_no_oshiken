module EnumHelper
  def enum_label(model, attr)
    I18n.t(
      "enums.#{model.model_name.i18n_key}.#{attr}.#{model.public_send(attr)}",
      default: model.public_send(attr).to_s.humanize
    )
  end
end