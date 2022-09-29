;-*- Emacs-Lisp -*-
;T'SoundSystem mode
;------------------
;$Id: tss-mode.el,v 1.1 2005/12/22 21:14:46 toyoshim Exp $

(defun tss-mode ()
  (interactive)
  (kill-all-local-variables)
  (setq buffer-mode 'tss-mode)
  (setq mode-name "T'SoundSystem")

  ; coment
  (highlight-phrase "{[^}]*}" 'hi-red-b)

  ; system directive
  (highlight-phrase "^\#TITLE[ \t]+<[^>]*>" 'hi-blue-b)
  (highlight-phrase "^\#CHANNEL[ \t]+[0-9]+" 'hi-blue-b)
  (highlight-phrase "^\#OCTAVE" 'hi-blue-b)
  (highlight-phrase "^\#VOLUME" 'hi-blue-b)
  (highlight-phrase "^\#FINENESS[ \t]+[0-9]+" 'hi-blue-b)
  (highlight-phrase "^\#WAV" 'hi-blue-b)  
  (highlight-phrase "^\#END" 'hi-blue-b)
  (highlight-phrase "^\#TABLE" 'hi-blue-b)
  (highlight-phrase "^\#[A-Z]" 'hi-blue-b)

  ; repeat
  (highlight-phrase "/:" 'hi-pink)
  (highlight-phrase "/" 'hi-pink)
  (highlight-phrase ":/" 'hi-pink)

  ; relative-oct.
  (highlight-phrase "<" 'hi-blue)
  (highlight-phrase ">" 'hi-blue)

  ; const val
  (highlight-phrase "NORMAL" 'hi-green-b)

  ; MML
  (highlight-phrase "%[0-9]+" 'hi-green-b)
  (highlight-phrase "@[0-9]+" 'hi-green-b)
  (highlight-phrase "@v[0-9]+" 'hi-green-b)
  (highlight-phrase "v[0-9]+" 'hi-green-b)
  (highlight-phrase "o[0-9]+" 'hi-green-b)
  (highlight-phrase "l[0-9]+" 'hi-green-b)
  (highlight-phrase "q[0-9]+" 'hi-green-b)
  (highlight-phrase "t[0-9]+" 'hi-green-b)
  (highlight-phrase "s[0-9]*,?-?[0-9]*" 'hi-green-b)
  (highlight-phrase "k-?[0-9]+" 'hi-green-b)
  (highlight-phrase "mp[0-9]+,[0-9]+,[0-9]+,[0-9]" 'hi-green-b)
  (highlight-phrase "na[0-9]+,[0-9]+" 'hi-green-b)
  (highlight-phrase "x[0-9]+,[0-9]+" 'hi-green-b)
  )
