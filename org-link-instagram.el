;;; org-link-instagram.el --- Description -*- lexical-binding: t; -*-
;;
;; Copyright (C) 2022 Cash Weaver
;;
;; Author: Cash Weaver <cashbweaver@gmail.com>
;; Maintainer: Cash Weaver <cashbweaver@gmail.com>
;; Created: March 13, 2022
;; Modified: March 13, 2022
;; Version: 0.0.1
;; Homepage: https://github.com/cashweaver/org-link-instagram
;; Package-Requires: ((emacs "27.1"))
;;
;; This file is not part of GNU Emacs.
;;
;;; Commentary:
;;
;;  This library provides an instagram link in org-mode.
;;
;;; Code:

(require 'ol)
(require 's)

(defcustom org-link-instagram-url-base
  "https://instagram.com"
  "The URL of Instagram."
  :group 'org-link-follow
  :type 'string
  :safe #'stringp)

(defun org-link-instagram--build-uri (path)
  "Return a uri for the provided PATH."
  (url-encode-url
   (s-format
    "${base-url}/${path}"
    'aget
    `(("base-url" . ,org-link-instagram-url-base)
      ("path" . ,path)))))

(defun org-link-instagram-open (path arg)
  "Opens an instagram type link."
  (let ((uri
         (org-link-instagram--build-uri
          path)))
    (browse-url
     uri
     arg)))

(defun org-link-instagram-export (path desc backend info)
  "Export an instagram link.

- PATH: the name.
- DESC: the description of the link, or nil.
- BACKEND: a symbol representing the backend used for export.
- INFO: a a plist containing the export parameters."
  (let ((uri
         (org-link-instagram--build-uri
          path)))
    (pcase backend
      (`html
       (format "<a href=\"%s\">%s</a>" uri (or desc uri)))
      (`latex
       (if desc (format "\\href{%s}{%s}" uri desc)
         (format "\\url{%s}" uri)))
      (`ascii
       (if (not desc) (format "<%s>" uri)
         (concat (format "[%s]" desc)
                 (and (not (plist-get info :ascii-links-to-notes))
                      (format " (<%s>)" uri)))))
      (`texinfo
       (if (not desc) (format "@uref{%s}" uri)
         (format "@uref{%s, %s}" uri desc)))
      (_ uri))))

(org-link-set-parameters
 "instagram"
 :follow #'org-link-instagram-open
 :export #'org-link-instagram-export)


(provide 'org-link-instagram)
;;; org-link-instagram.el ends here
