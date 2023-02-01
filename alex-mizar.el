;;; alex-mizar.el --- Helper Macros for Literate Theorem Proving in Mizar  -*- lexical-binding: t; -*-

;; Copyright (C) 2023  

;; Author: Alex Nelson <pqnelson@gmail.com>
;; Keywords: 

;; This program is free software; you can redistribute it and/or modify
;; it under the terms of the GNU General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; (at your option) any later version.

;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.

;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <https://www.gnu.org/licenses/>.

;;; Commentary:

;; 

;;; Code:

(defvar mizar-lit-dir "c:/src/mizar-playground/nw/")

(defun count-lit-mizar-files ()
  (length (directory-files mizar-lit-dir nil "\\.nw\\'")))

(defun alex-mizar/initialize-nw-file (article-name full-file-path mizar-id)
  (interactive)
  (find-file (concat full-file-path ".nw"))
  (insert "% -*- mode: poly-noweb; noweb-code-mode: mizar-mode; -*-\n\n")
  (insert "\\chapter{" article-name "}\n\n\n")
  (insert "\\section{Mizar Article}\n\n\n")
  (insert "<<TEXT/" (replace-regexp-in-string "_" "-" mizar-id) ".miz>>=\n")
  (insert "<<License for [[" mizar-id ".miz]]>>\n\n")
  (insert "<<Environment for [[" mizar-id ".miz]]>>\n\n")
  (insert "<<[[" mizar-id ".miz]] article body>>\n@\n\n")
  (insert "\\bigskip\n")
  (insert "\\subsection*{Vocabulary File}\n\n")
  (insert "<<DICT/" (replace-regexp-in-string "_" "-" mizar-id) ".voc>>=\n")
  (insert "@\n\n")
  (insert "\\subsection*{License}\n")
  (insert "The license for the MML seems to be the same for each article, I will\njust copy it over.\n\n")
  (insert "<<License for [[" mizar-id ".miz]]>>=\n")
  (insert ":: " article-name "\n")
  (insert "::  by Alexander M. Nelson
::
:: This code can be distributed under the GNU General Public Licence
:: version 3.0 or later, or the Creative Commons Attribution-ShareAlike
:: License version 3.0 or later, subject to the binding interpretation
:: detailed in file COPYING.interpretation.
:: See COPYING.GPL and COPYING.CC-BY-SA for the full text of these
:: licenses, or see http://www.gnu.org/licenses/gpl.html and
:: http://creativecommons.org/licenses/by-sa/3.0/.

@\n")
  (save-buffer)
  (kill-buffer))

(defun alex-mizar/environ-directive (id directive)
  (interactive)
  (insert "\\subsection{" (capitalize directive) "}\n")
  (insert "<<[[" id "]] " (downcase directive) ">>=\n")
  (insert (downcase directive) " ")
  (when (string= "requirements" directive)
    (insert "BOOLE, SUBSET, NUMERALS, ARITHM, REAL"))
  (insert ";\n")
  (insert "@\n\n"))
  
(defun alex-mizar/environ-file (directory-path mizar-id)
  (interactive)
  (let ((id (concat mizar-id ".miz")))
    (find-file (concat directory-path "environ.nw"))
    (insert "% -*- mode: poly-noweb; noweb-code-mode: mizar-mode; -*-\n")
    (insert "\\section{Environment}\n\n")
    (insert "<<Environment for [[" id "]]>>=\n")
    (insert "environ\n\n")
    (insert "  <<[[" id "]] vocabularies>>\n\n")
    (insert "  <<[[" id "]] constructors>>\n\n")
    (insert "  <<[[" id "]] notations>>\n\n")
    (insert "  <<[[" id "]] registrations>>\n\n")
    (insert "  <<[[" id "]] requirements>>\n\n")
    (insert "  <<[[" id "]] definitions>>\n\n")
    (insert "  <<[[" id "]] equalities>>\n\n")
    (insert "  <<[[" id "]] expansions>>\n\n")
    (insert "  <<[[" id "]] theorems>>\n\n")
    (insert "  <<[[" id "]] schemes>>\n\n")
    (insert "@\n\n")
    (alex-mizar/environ-directive id "vocabularies")
    (alex-mizar/environ-directive id "constructors")
    (alex-mizar/environ-directive id "notations")
    (alex-mizar/environ-directive id "registrations")
    (alex-mizar/environ-directive id "requirements")
    (alex-mizar/environ-directive id "definitions")
    (alex-mizar/environ-directive id "equalities")
    (alex-mizar/environ-directive id "expansions")
    (alex-mizar/environ-directive id "theorems")
    (alex-mizar/environ-directive id "schemes")
    (save-buffer)
    (kill-buffer)))

(defun alex-mizar/article-index (directory-path mizar-id)
  (interactive)
  (let ((id (concat mizar-id ".miz")))
    (find-file (concat directory-path "index.nw"))
    (insert "% -*- mode: poly-noweb; noweb-code-mode: mizar-mode; -*-\n")
    (insert "\\section{Roadmap}\n\n")
    (insert "<<[[" id "]] article body>>=\n")
    (insert "@\n")
    (save-buffer)
    (kill-buffer)))

(defun start-article ()
  (interactive)
  (let* ((article-title (read-string "New article title: " nil))
         (article-file-name (read-string "File name: " nil))
         (mizar-id (read-string "Mizar Identifier: " nil))
         (file-path (concat mizar-lit-dir
                            (format "%03d" (1+ (count-lit-mizar-files)))
                            "-"
                            article-file-name))
         (dir-path (concat file-path "/")))
    (alex-mizar/initialize-nw-file article-title file-path mizar-id)
    (make-directory dir-path)
    (alex-mizar/environ-file dir-path mizar-id)
    (alex-mizar/article-index dir-path mizar-id)))

(provide 'alex-mizar)
;;; alex-mizar.el ends here
