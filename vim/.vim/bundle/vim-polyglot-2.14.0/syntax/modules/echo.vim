if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'nginx') == -1
  
" Echo Module <https://www.nginx.com/resources/wiki/modules/echo/>
" Bringing the power of "echo", "sleep", "time" and more to Nginx's config file
syn keyword ngxDirectiveThirdParty echo
syn keyword ngxDirectiveThirdParty echo_duplicate
syn keyword ngxDirectiveThirdParty echo_flush
syn keyword ngxDirectiveThirdParty echo_sleep
syn keyword ngxDirectiveThirdParty echo_blocking_sleep
syn keyword ngxDirectiveThirdParty echo_reset_timer
syn keyword ngxDirectiveThirdParty echo_read_request_body
syn keyword ngxDirectiveThirdParty echo_location_async
syn keyword ngxDirectiveThirdParty echo_location
syn keyword ngxDirectiveThirdParty echo_subrequest_async
syn keyword ngxDirectiveThirdParty echo_subrequest
syn keyword ngxDirectiveThirdParty echo_foreach_split
syn keyword ngxDirectiveThirdParty echo_end
syn keyword ngxDirectiveThirdParty echo_request_body
syn keyword ngxDirectiveThirdParty echo_exec
syn keyword ngxDirectiveThirdParty echo_status
syn keyword ngxDirectiveThirdParty echo_before_body
syn keyword ngxDirectiveThirdParty echo_after_body


endif
