(defvar lcal:mode-hook)

(defvar lcal:mode-map nil
  "The keymap for the lunar calendar buffers.")

(defvar lcal:day-offset 0)

(defvar lcal:month-offset 0)

(defvar lcal:year-offset 0)

(defvar lcal:buffer-name "*Lunar Calendar*")

(defun lcal:get-current-timestamp()
  (format-time-string "%s"))

(defun lcal:get-date-string()
  (interactive)
  (let ((day (string-to-number (format-time-string "%d")))
	(month (string-to-number (format-time-string "%m")))
	(year (string-to-number (format-time-string "%Y"))))
    (format-time-string "%d%m%Y" (encode-time 0 0 0 (+ day lcal:day-offset) (+ month lcal:month-offset) (+ year lcal:year-offset)))))

(defun lcal:render()
  (interactive)
  (erase-buffer)
  (setq command (concat "licham " "-d " (lcal:get-date-string)))
  (shell-command command lcal:buffer-name)
  (ansi-color-apply-on-region (point-min) (point-max))
  )

(defun lcal:show-calendar-buffer()
  (interactive)
  (progn
    (switch-to-buffer lcal:buffer-name)
    (lcal:mode)
    (lcal:render)
    )
  )

(defun lcal:mode()
  (interactive)
  ;; (setq buffer-read-only t)
  (kill-all-local-variables)
  (use-local-map lcal:mode-map)
  (setq lcal:mode-map nil)
  (setq mode-name "*Lunar Calendar*")
  (setq major-mode 'lcal:mode)
  (run-hooks 'lcal:mode-hook))

(defun lcal:prev-day()
  (interactive)
  (setq lcal:day-offset (- lcal:day-offset 1))
  (lcal:render))

(defun lcal:next-day()
  (interactive)
  (setq lcal:day-offset (+ lcal:day-offset 1))
  (lcal:render))

(defun lcal:prev-week()
  (interactive)
  (setq lcal:day-offset (- lcal:day-offset 7))
  (lcal:render))

(defun lcal:next-week()
  (interactive)
  (setq lcal:day-offset (+ lcal:day-offset 7))
  (lcal:render))

(defun lcal:prev-month()
  (interactive)
  (setq lcal:month-offset (- lcal:month-offset 1))
  (lcal:render))

(defun lcal:next-month()
  (interactive)
  (setq lcal:month-offset (+ lcal:month-offset 1))
  (lcal:render))

(defun lcal:prev-year()
  (interactive)
  (setq lcal:year-offset (- lcal:year-offset 1))
  (lcal:render))

(defun lcal:next-year()
  (interactive)
  (setq lcal:year-offset (+ lcal:year-offset 1))
  (lcal:render))

(if lcal:mode-map
    nil
  (let ((map (make-sparse-keymap)))
    (define-key map (kbd "C-n") 'lcal:next-year)
    (define-key map (kbd "C-p") 'lcal:prev-year)
    (define-key map (kbd "C-f") 'lcal:next-month)
    (define-key map (kbd "C-b") 'lcal:prev-month)
    (define-key map (kbd "n") 'lcal:next-week)
    (define-key map (kbd "p") 'lcal:prev-week)
    (define-key map (kbd "f") 'lcal:next-day)
    (define-key map (kbd "b") 'lcal:prev-day)
    (define-key map (kbd "<up>") 'lcal:prev-week)
    (define-key map (kbd "<down>") 'lcal:next-week)
    (define-key map (kbd "<left>") 'lcal:prev-day)
    (define-key map (kbd "<right>") 'lcal:next-day)
    (define-key map (kbd "<C-up>") 'lcal:prev-year)
    (define-key map (kbd "<C-down>") 'lcal:next-year)
    (define-key map (kbd "<C-left>") 'lcal:prev-month)
    (define-key map (kbd "<C-right>") 'lcal:next-month)
    (setq lcal:mode-map map)))

(provide 'lcal)
