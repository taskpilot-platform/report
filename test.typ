#set page(width: 10cm, height: auto)
#show raw: it => {
  if it.block {
    it
  } else {
    show regex("[._/,\-()=]"): char => char + sym.zws
    it
  }
}
This is a test: `nextval('public.password_reset_tokens_id_seq'::regclass)` in a very narrow page to see if it wraps.
