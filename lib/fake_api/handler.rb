module FakeApi
  class Handler

    def Handler.handle(method, path:, params: {}, headers: {})
      if route = Handler.resolve(method, path)
        route.value.call
      else
        # READ MORE: https://github.com/igorkasyanchuk/fake_api
        raise "Route /#{path} was not found.<br/>Please edit your fake_api rounting file(s).<br/>Available:<br/><small style='font-size: 10px; line-height: 10px;'>#{available.presence || 'NONE'}</small>".html_safe
      end
    end

    private

    def Handler.resolve(method, path)
      FakeApiData.instance.routes.fetch(method, {}).each do |k, v|
        return v if "/#{path}" == k
        return v if k.is_a?(Regexp) && "/#{path}" =~ k
      end
      nil
    end

    def Handler.available
      result = []
      FakeApiData.instance.routes.collect do |method, route|
        route.each do |k, v|
          result << "#{method} #{FakeApi::Engine.mounted_in}#{k}"
        end
      end
      result.sort.join("<br/>")
    end

  end
end