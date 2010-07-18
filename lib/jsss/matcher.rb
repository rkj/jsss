require 'json'
module JSON::Spec
  class Matcher
    DataTypes = {
      :String => String,
      :Integer => Numeric
    }
    def initialize(spec)
      @spec = if spec.is_a? String
        Parser.new(spec).parse
      else
         spec
       end
    end
  
    def match(obj)
      obj = JSON.parse(obj) if obj.is_a? String
      do_match(obj, @spec)
    end # match
    
    private
    def do_match(obj, m)
      return false if obj.nil?
      if m.is_a? Symbol
        # todo user defined data types
        return obj.is_a? DataTypes[m]
      elsif m.is_a? String
        return m == obj
      end
      return false unless (obj.class == m.class)
      if obj.is_a? Array
        obj.all? { |e| do_match(e, m.first) }
      elsif obj.is_a? Hash
        tmp = obj.clone
        syms, others = m.to_a.partition { |k, v| k.is_a? Symbol }
        raise 'There should be only one sym key' if syms.length > 1
        sym = syms.first
        others.all? { |k, v| do_match(tmp.delete(k), v) } &&
        tmp.all? { |k, v| do_match(k, sym[0]) && do_match(v, sym[1])}
      else
        true
      end      
    end # do_match(obj, m)  
  end # class Matcher
end # module