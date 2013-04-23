class StatusDisplay
  def initialize(app)
    @app = app
  end

  def call(env)
    @status, @headers, @response = @app.call(env)

    [@status, @headers, self]
  end

  def each(&blk)
    @response.each(&blk)

    if @headers['Content-Type'].include? 'application/json'
      output = blk.call
      output[0] = append_status(output[0])
      update_content_length(output[0])
      output
    end
  end

  private

  def status_string
    "\"status\":#{@status}" << '}'
  end

  def append_status(output)
    output.gsub(/}$/, ",#{status_string}")
  end

  def update_content_length(output)
    @headers['Content-Length'] = output.length.to_s
  end
end
