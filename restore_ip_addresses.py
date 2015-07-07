MAX_OCTET = 255


def restore_ip_addresses(string):
    """ Produce a list of valid ipv4 addresses out of the provided string
    :param string: a string of length between 4 and 12 containing only numerics
    :return: a list of valid ipv4 addresses as a list of strings representing
    ipv4 addresses
    """
    valid_ips = []

    # Only process the string if it's between 4 and 12 characters and contains
    # only digits
    if 3 < len(string) < 13 and string.isdigit():
        _process_ip_string(string, [], valid_ips)
        # Output the valid ip addresses
        for address in valid_ips:
            print address

    return valid_ips


def _process_ip_string(string, octets, valid_ips):
    """ Used to recurse through a string and produce valid octets to try to
    produce a valid ipv4 address
    :param string: the remaining portion of the string to process
    :param octets: the octets found thus far, processing the string before this
    invocation
    :param valid_ips: the results array, contains valid ip addresses as a list
     of ipv4 strings in dotted notation
    :return: a list containing a valid ip address or None if unable to create a
    valid ip address out of the provided inputs
    """

    # Our halting state is that we've found four valid octets and there's no
    # more characters remaining in the string
    if len(octets) == 4:
        if len(string):
            # If there is still some of the string remaining we didn't build a
            # successful ip address
            return None
        else:
            # Looks like we got a valid ip, build the IP string and return it
            return _join_octets(octets)

    # Let's try to build a valid ip address
    # Run through the next three characters attempting to build an ip address
    # if it's a valid octet
    for i in range(1, 4):
        # If we don't check that we aren't past the end of the string we'll get
        # duplicates of the same IP since Python is kind about string splitting
        if i <= len(string):
            octet = string[0:i]
            remaining_str = string[i:]
            # No point continuing if the octet we've created isn't valid
            if _valid_octet(octet):
                # See if we can build up a full ip with this, recursion time
                ip_addr = _process_ip_string(remaining_str, octets + [octet],
                                             valid_ips)
                # If we successfully generated a valid IP address store it in
                # the result array
                if ip_addr:
                    valid_ips.append(ip_addr)


def _valid_octet(octet):
    return octet and int(octet) <= MAX_OCTET


def _join_octets(octets):
    return '.'.join(str(octet) for octet in octets)


def _assert_lists_contain_same(list1, list2):
    assert len(set(list1).intersection(list2)) == len(list1) == len(list2)


# Run some tests to make sure everything is working
_assert_lists_contain_same(restore_ip_addresses("2552551231"),
                           ['255.25.51.231', '255.255.1.231',
                            '255.255.12.31', '255.255.123.1'])
_assert_lists_contain_same(restore_ip_addresses("1111345"),
                           ['1.1.113.45', '1.11.13.45', '1.11.134.5',
                            '1.111.3.45', '1.111.34.5', '11.1.13.45',
                            '11.1.134.5', '11.11.3.45', '11.11.34.5',
                            '11.113.4.5', '111.1.3.45', '111.1.34.5',
                            '111.13.4.5'])
_assert_lists_contain_same(restore_ip_addresses("11111111111"),
                           ['11.111.111.111', '111.11.111.111',
                            '111.111.11.111', '111.111.111.11'])

# Test some error cases
assert len(restore_ip_addresses("1EE11111111")) == 0
assert len(restore_ip_addresses("55555555555")) == 0
assert len(restore_ip_addresses("111")) == 0