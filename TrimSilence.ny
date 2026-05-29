;nyquist plug-in
;version 1
;type process
;categories "http://lv2plug.in/ns/lv2core/#UtilityPlugin"
;name "Trim Silence..."
;action "Trimming..."
;info "by Steve Daulton (www.easyspacepro.com). Released under GPL v2.\n\nTrims silence from the beginning and end of the selection.\n"

;control thresh "Silence Threshold (dB)" real "" -48 -100 0

;; TrimSilence.ny by Steve Daulton. Aug 2011.
;; Released under terms of the GNU General Public License version 2:
;; http://www.gnu.org/licenses/old-licenses/gpl-2.0.html
;; Requires Audacity 1.3.8 or later.

;convert threhold to linear
(setq thresh (db-to-linear (min 0 thresh)))

;modulo
(defun mod (x y)
	(setq y (float y))
	(round (* y(-(/ x y)(truncate(/ x y))))))
	
;convert to hh:mm:ss
(defun to-hhmmss (seconds)
	(let* ((hh (truncate (/ seconds 3600)))
				(mm (truncate (/ (mod seconds 3600) 60)))
				(ss (mod seconds 60)))
		(format nil "~ah:~am:~as" hh mm ss)))

(if (< len ny:all) ;max length that can be processed
	(let*
			;make stereo sound mono
			((mysound (if (arrayp s)(s-max (aref s 0)(aref s 1)) s))
			(start-count 0)
			(end-count 0)
			(flag 0)
			;ratio provides tighter trimming for short selections
			;while maintaining reasonable speed for long selections
			(ratio (max 10(min 200 (round (/ len 100000.0)))))
			(my-srate (/ *sound-srate* ratio))
			(mysound (snd-avg mysound ratio ratio op-peak))
			(samples (snd-length mysound ny:all)))
		;loop through samples
		(dotimes (i samples)
			(setq new (snd-fetch mysound))
			(cond 
				((= flag 0)
					;count initial silence
					(if (<= new thresh)
						(setq start-count (1+ start-count))
						(setq flag 1)))
				(T
					;count final silence
					(if (<= new thresh)
						(setq end-count (1+ end-count))
						(setq end-count 0)))))

		(let ((start (/ start-count my-srate))
					(end (-(get-duration 1)(/ end-count my-srate))))
			;ensure at least 1 sample remains
			(if (>= start (get-duration 1))
				(setq start (/(1- len)*sound-srate*)))
			;trim
			(multichan-expand #'extract-abs start end (cue s))))
	;OR print error message
	(format nil 
"Error.\nMaximum selected duration at ~a Hz is ~a.~%Selected track is ~a.~%"
	(round *sound-srate*)
	(to-hhmmss (/ ny:all *sound-srate*))
	(to-hhmmss (get-duration 1))))
