if !exists('g:polyglot_disabled') || index(g:polyglot_disabled, 'nginx') == -1
  
" Events Module (DEPRECATED) <http://docs.dutov.org/nginx_modules_events_en.html>
" Provides options for start/stop events.
syn keyword ngxDirectiveDeprecated on_start
syn keyword ngxDirectiveDeprecated on_stop


endif
