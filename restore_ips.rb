MAX_OCTET = 255

class RestoreIps

  def get_valid_addrs(ip_string)

    # Only process the string if it's between 4 and 12 characters and contains only digits
    raise StandardError, 'String must be between 4 and 12 characters and contain only digits' if not ip_string.length.between?(4, 12) or not ip_string.to_i.to_s == ip_string

    valid_ips = Array.new
    process_ip_string(ip_string, Array.new, valid_ips)
    puts valid_ips
    valid_ips
  end

  private
  def process_ip_string(string, octets, valid_ips)
    if octets.length == 4
      if string.length > 0
        # If there is still some of the string remaining we didn't build a
        # successful ip address
        return NIL
      else
        # Looks like we got a valid ip, build the IP string and return it
        return join_octets(octets)
      end
    end

    # Let's try to build a valid ip address
    # Run through the next three characters attempting to build an ip address
    # if it's a valid octet
    (1..3).each { |i|
      # If we don't check that we aren't past the end of the string we'll get
      # duplicates of the same IP
      if string != NIL and i <= string.length
        octet = string[0, i]
        remaining_str = string[i..-1]
        # puts "octet: #{octet} remaining_str: #{remaining_str}"
        # No point continuing if the octet we've created isn't valid
        if valid_octet(octet)
          # See if we can build up a full ip with this, recursion time
          ip_addr = process_ip_string(remaining_str, octets + [octet],
                                      valid_ips)
          # If we successfully generated a valid IP address store it in
          # the result array
          if ip_addr != NIL
            valid_ips.push(ip_addr)
          end
        end
      end
    }
    NIL
  end

  private
  def valid_octet(octet)
    octet != NIL and octet.to_i <= MAX_OCTET
  end

  private
  def join_octets(octets)
    octets.join('.')
  end

end

def assert_arrays_same(a1, a2)
  raise 'Fail' unless a1.uniq.sort == a2.uniq.sort

end

# Run through some test cases
res_ips = RestoreIps.new
assert_arrays_same(res_ips.get_valid_addrs("2552551231"),
                   Array['255.25.51.231', '255.255.1.231',
                         '255.255.12.31', '255.255.123.1'])

assert_arrays_same(res_ips.get_valid_addrs("1111345"),
                   Array['1.1.113.45', '1.11.13.45', '1.11.134.5',
                         '1.111.3.45', '1.111.34.5', '11.1.13.45',
                         '11.1.134.5', '11.11.3.45', '11.11.34.5',
                         '11.113.4.5', '111.1.3.45', '111.1.34.5',
                         '111.13.4.5'])

assert_arrays_same(res_ips.get_valid_addrs("11111111111"),
                   Array['11.111.111.111', '111.11.111.111',
                         '111.111.11.111', '111.111.111.11'])

assert_arrays_same(res_ips.get_valid_addrs("2222"), Array['2.2.2.2'])

assert_arrays_same(res_ips.get_valid_addrs("55555555555"), Array[])

# Run through some error cases

begin
  res_ips.get_valid_addrs("1EE11111111")
  raise 'Fail'
rescue StandardError
end

begin
  res_ips.get_valid_addrs("11.11.11.11")
  raise 'Fail'
rescue StandardError
end

begin
  res_ips.get_valid_addrs("1111111111111")
  raise 'Fail'
rescue StandardError
end

begin
  res_ips.get_valid_addrs("111")
  raise 'Fail'
rescue StandardError
end