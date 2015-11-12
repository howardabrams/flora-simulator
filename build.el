(require 'org)
(require 'ox-publish)
(setq org-html-postamble nil)
(setq org-publish-project-alist '(("ada"
                                   :base-directory "tutorial-src"
                                   :publishing-directory "tutorial"
                                   :publishing-function org-html-publish-to-html
                                   :section-numbers nil
                                   :with-toc nil)))
(org-publish-project "ada")
