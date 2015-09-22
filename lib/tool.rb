module PrezRunner
  class Tool
    def self.ip
      Socket.ip_address_list.detect{|intf| intf.ipv4_private?}.ip_address
    end
  end
end