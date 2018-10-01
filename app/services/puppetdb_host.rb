class PuppetdbHost
  attr_accessor :certname, :environment, :facts

  def initialize(opts = {})
    self.facts = HashWithIndifferentAccess.new
    parse_facts(opts.fetch(:facts))
  end

  def to_host
    host = Host::Managed.import_host(facts[:fqdn], certname)
    host.import_facts(facts)
    host.update_attribute(:environment => environment) if environment
    host
  end

  private

  def parse_facts(pdb_facts)
    pdb_facts.each do |fact|
      name = fact['name']
      value = parse_fact_value(fact['value'])
      facts[name] = value
      self.certname = fact['certname']
      self.environment = fact['environment']
    end
  end

  def parse_fact_value(value)
    result = value.is_a?(String) ? JSON.parse(value) : value
    return result.to_s unless result.is_a?(Hash)
    deep_stringify_values(result)
  rescue JSON::ParserError
    value.to_s
  end

  def deep_stringify_values(obj)
    result = {}
    obj.each do |key, value|
      result[key] = if value.is_a?(Hash)
                      deep_stringify_values(value)
                    else
                      value.to_s
                    end
    end
    result
  end
end
