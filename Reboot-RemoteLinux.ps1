# Reboot Linux host over SSH. Uses your default SSH identity (~/.ssh/id_ed25519 or ssh-agent).
# Expect "Connection closed" — the server drops the session while rebooting.

$RemoteUser = 'root'
$RemoteHost = '104.131.180.215'

ssh "${RemoteUser}@${RemoteHost}" 'reboot'
