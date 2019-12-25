class SerializerRegistry
  class Container
    extend Dry::Container::Mixin

    register(User, UserSerializer)
  end

  def self.render_json(model)
    Container[model.class].new(model).serializable_hash
  end
end
