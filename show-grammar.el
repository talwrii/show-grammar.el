;;; show-grammar-mode.el --- Highlight grammatical features in emacs for proof reading.
;;
;; Used artbollocks-mode as a scaffold, which was written by Sacha Chaua

;; Author: Tal Wrii, Rob Myers <rob@robmyers.org>, Sacha Chua <sacha@sachachua.com>
;; URL: https://github.com/talwrii/show-grammar-mode
;; Version: 1.1.2

;;
;; Based on fic-mode.el
;; Copyright (C) 2010, Trey Jackson <bigfaceworm(at)gmail(dot)com>
;;
;;
;; This program is free software: you can redistribute it and/or modify
;; it under the terms of the GNU Affero General Public License as published by
;; the Free Software Foundation, either version 3 of the License, or
;; at your option any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with this program.  If not, see <http://www.gnu.org/licenses/>.
;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Commentary:

;; This project is very much experimental. The idea is that when *writing* and editing
;; (rather than reading) some sort of "syntax highlighting" of grammatical features can
;; improve one's writing both in terms of catching mistakes early and make the writing
;; choices one is making more apparent. 

;; When coding syntax highlighting can act as a sort of "six sense" making one aware
;; of things you might not otherwise we aware of. Over time one notices when the
;; syntax highlighter does not behave as expected causing one to detect errors and choices
;; it is hoped that a similar sort of process can take place when writing and editing.

;; Usage
;;
;; To use, save show-grammar-mode.el to a directory in your load-path or install with straight
;;
;; (require 'show-grammar)
;; (add-hook 'text-mode-hook 'show-grammar-mode)
;;
;; or
;;
;; M-x show-grammar-mode
;;
;; The default mode is quite "colorful". You might prefer to look at different types
;; of highlighting in order for different steps of proof reading.
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;; Code:

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Customization
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Enable features individually
(require 's)

(defvar show-grammar-log nil "Should we log")


(defun show-grammar-log ()
  "Toggle logging."
  (interactive)
  (setq show-grammar-log (not show-grammar-log))
  (if show-grammar-log
      (message "Show-grammar logging")
    (message "Show-grammar not logging")))

(defun show-grammar--log (format &rest args)
  (if show-grammar-log
      (apply 'message format args)))

(defcustom show-grammar-punct t
  "Where to fontify punctuation."
  :type '(boolean)
  :group 'show-grammar-mode)

(defcustom show-grammar-homophones t
  "Whether to check for homophones voice"
  :type '(boolean)
  :group 'show-grammar-mode)


(defcustom show-grammar-weasel-word t
  "Whether to check for weasel words"
  :type '(boolean)
  :group 'show-grammar-mode)

(defcustom show-grammar-jargon t
  "Whether to check for show-grammar jargon"
  :type '(boolean)
  :group 'show-grammar-mode)

(defface show-grammar-duplicate-face
  '((t (:foreground "black" :background "red")))
  "The face for lexical illusions words"
  :group 'show-grammar-mode)

(defface show-grammar-placeholder-face
  '((t (:foreground "black" :background "green")))
  "The face for lexical illusions words"
  :group 'show-grammar-mode)

(defface show-grammar-vague-face
  '((t (:foreground "black" :background "green")))
  "The face for vague things"
  :group 'show-grammar-mode)

(defface show-grammar-plural-face
  '((t (:foreground "black" :background "green")))
  "The face for plural things"
  :group 'show-grammar-mode)

(defface show-grammar-comment-face
  '((t (:foreground "gray" :background "black")))
  "The face for comments in emails"
  :group 'show-grammar-mode)

(defface show-grammar-quote-face
  '((t (:strike-through "red")))
  "The face for vague things"
  :group 'show-grammar-mode)

(defface show-grammar-punct-face
  '((t (:foreground "black" :background "gold")))
  "The face for lexical illusions words"
  :group 'show-grammar-mode)

(defface show-grammar-capital-face
  '((t (:foreground "black" :background "red")))
  "The face for lexical illusions words"
  :group 'show-grammar-mode)

(defface show-grammar-homophones-face
  '((t (:foreground "Gray" :background "White")))
  "The face for homophones"
  :group 'show-grammar-mode)

(defface  show-grammar-informal-face
  '((t (:foreground "black" :background "red")))
  "The face for informal language"
  :group 'show-grammar-mode)

(defface  show-grammar-conjunction-face
  '((t (:underline "yellow")))
  "The face for a conjunction"
  :group 'show-grammar-mode)

(defface  show-grammar-subordinator-face
  '((t (:underline "red")))
  "The face for a conjunction"
  :group 'show-grammar-mode)

(defface show-grammar-weasel-word-face
  '((t (:foreground "Brown" :background "White")))
  "The face for weasel-word words"
  :group 'show-grammar-mode)

(defface show-grammar-face-jargon
  '((t (:foreground "Purple" :background "White")))
  "The face for jargon words"
  :group 'show-grammar-mode)

(defface show-grammar-face-wrong
  '((t (:foreground "black" :background "red")))
  "The face for wrong words"
  :group 'show-grammar-mode)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Lexical illusions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq show-grammar-punct-regex "\\(:\\|,\\|\\?\\|\\.\\|\"\\)")

(setq show-grammar-placeholder-regex "\\b\\([Tt]his\\|[Ii]t\\|previously\\)\\b")


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Passive voice
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;



(setq show-grammar-homophones-words (s-split " " "hear here there their they're are days daze desert dessert dew due leach leech rouse rows accessory die dye lead led rung wrung ad add discreet leak leek rye wry ail ale discrete lean lien saver savour air heir doe doh lessen spade spayed aisle dough lesson sale sail isle done dun levee levy sane seine all awl douse dowse liar lyre satire satyr allowed draft licence sauce source aloud draught license saw soar sore alms arms dual duel licker sore altar alter earn urn liquor scene seen arc ark eery eyrie lie lye scull skull aren't aunt ewe yew lieu loo sea see ate eight faint feint links lynx seam seem auger augur fah far lo low sear seer auk orc fair fare load lode sere aural oral farther loan lone seas sees away aweigh father locks lox seize awe oar or fate fête loop loupe sew so sow ore faun fawn loot lute shake sheikh axel axle fay fey made maid shear sheer aye eye faze phase mail male shoe shoo bail bale feat feet main mane sic sick bait bate ferrule maize maze side sighed baize bays ferule mall maul sign sine bald bawled few phew manna manner sink synch ball bawl fie phi mantel slay sleigh band banned file phial mantle sloe slow bard barred find fined mare mayor sole soul bare bear fir fur mark marque some sum bark barque fizz phiz marshal son sun baron barren flair flare martial sort sought base bass flaw floor marten spa spar bay bey flea flee martin staid stayed bazaar flex flecks mask masque stair stare bizarre flew flu maw more stake steak be bee flue me mi stalk stork beach beech floe flow mean mien stationary bean been flour flower meat meet stationery beat beet foaled fold mete steal steel beau bow for fore medal meddle stile style beer bier four metal mettle storey story bel bell foreword meter metre straight belle forward might mite strait berry bury fort fought miner minor sweet suite berth birth forth fourth mynah swat swot bight bite foul fowl mind mined tacks tax byte franc frank missed mist tale tail billed build freeze moat mote talk torque bitten frieze tare tear bittern friar fryer moor more taught taut blew blue furs furze moose mousse tort bloc block gait gate morning te tea tee boar bore galipot mourning team teem board bored gallipot muscle tear tier boarder gallop galop mussel teas tease border gamble naval navel terce terse bold bowled gambol nay neigh tern turn boos booze gays gaze nigh nye there their born borne genes jeans none nun they're bough bow gild guild od odd threw boy buoy gilt guilt ode owed through brae bray giro gyro oh owe throes braid brayed gnaw nor one won throws braise gneiss nice packed pact throne brays braze gorilla packs pax thrown brake break guerilla pail pale thyme time bread bred grate great pain pane tic tick brews bruise greave pair pare tide tied bridal grieve pear tire tyre bridle greys graze palate too to two broach grisly palette toad toed brooch grizzly pallet towed bur burr groan grown pascal told tolled but butt guessed paschal tole toll buy by bye guest paten ton tun buyer byre hail hale patten tor tore calendar hair hare pattern tough tuff calender hall haul pause paws troop troupe call caul hangar pores pours tuba tuber canvas hanger pawn porn vain vane canvass hart heart pea pee vein cast caste haw hoar peace piece vale veil caster whore peak peek vial vile castor hay hey peke pique wail wale caught court heal heel peal peel whale caw core he'll pearl purl wain wane corps hear here pedal peddle waist waste cede seed heard herd peer pier wait weight ceiling he'd heed pi pie waive wave sealing heroin pica pika wall waul cell sell heroine place plaice war wore censer hew hue plain plane ware wear censor hi high pleas please where sensor higher hire plum plumb warn worn cent scent him hymn pole poll wart wort sent ho hoe poof pouffe watt cereal hoard horde practice wax whacks serial hoarse horse practise way weigh cheap cheep holey holy praise whey check cheque wholly prays preys we wee whee choir quire hour our principal weak week chord cord idle idol principle we'd weed cite sight profit weal we'll site indict prophet wheel clack claque indite quarts wean ween clew clue it's its quartz weather climb clime jewel joule quean queen whether close cloze key quay rain reign weaver coal kohl knave nave rein weever coarse knead need raise rays weir we're course knew new raze were whirr coign coin knight night rap wrap wet whet colonel knit nit raw roar wheald kernel knob nob read reed wheeled complacent knock nock read red which witch complaisant knot not real reel whig wig complement know no reek wreak while wile compliment knows nose rest wrest whine wine coo coup laager lager retch wretch whirl whorl cops copse lac lack review revue whirled council lade laid rheum room world counsel lain lane right rite whit wit cousin cozen lam lamb wright write white wight creak creek laps lapse ring wring who's whose crews cruise larva lava road rode woe whoa cue kyu lase laze roe row wood would queue law lore role roll yaw yore curb kerb lay ley roo roux your you're currant lea lee rue yoke yolk you'll yule cymbol root route symbol rose rows dam damn rota rotor days daze rote wrote dear deer rough ruff descent dissent desert dessert deviser divisor descendant descendent amount workaround placeholder"))

(setq show-grammar-bad-words
      (list "In fact," "Ironically[^,]" "Nevertheless[^,]"))

(setq show-grammar-homophones-regex (s-concat "\\b\\(" (s-join "\\|" (append show-grammar-bad-words (list "one liners" "command line" "work around" "placeholder") show-grammar-homophones-words)) "\\)\\b"))
















;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Weasel words
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq show-grammar-weasel-word-regex "\\b\\(basically\\|many\\|various\\|very\\|fairly\\|several\\|extremely\\|exceedingly\\|quite\\|remarkably\\|few\\|surprisingly\\|mostly\\|largely\\|huge\\|tiny\\|\\(\\(are\\|is\\) a number\\)\\|excellent\\|interestingly\\|significantly\\|substantially\\|clearly\\|vast\\|relatively\\|completely\\|quickly\|easily\|just\\)\\b")





;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Show-grammar
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq show-grammar-wrong-regex "\\b\\(free *rain\\|free *reign\\|bare *in *mind\\|bair *in *mind\\)\\b")

(setq show-grammar-jargon-regex "\\b\\(a priori\\|ad hoc\\|affirmation\\|affirm\\|affirms\\|alterity\\|altermodern\\|aporia\\|aporetic\\|appropriates\\|appropriation\\|archetypal\\|archetypical\\|archetype\\|archetypes\\|autonomous\\|autonomy\\|baudrillardian\\|baudrillarian\\|commodification\\|committed\\|commitment\\|commonalities\\|contemporaneity\\|context\\|contexts\\|contextual\\|contextualise\\|contextualises\\|contextualisation\\|contextialize\\|contextializes\\|contextualization\\|contextuality\\|convention\\|conventional\\|conventions\\|coterminous\\|critique\\|cunning\\|cunningly\\|death of the author\\|debunk\\|debunked\\|debunking\\|debunks\\|deconstruct\\|deconstruction\\|deconstructs\\|deleuzian\\|desire\\|desires\\|dialectic\\|dialectical\\|dialectically\\|discourse\\|discursive\\|disrupt\\|disrupts\\|engage\\|engagement\\|engages\\|episteme\\|epistemic\\|ergo\\|fetish\\|fetishes\\|fetishise\\|fetishised\\|fetishize\\|fetishized\\|gaze\\|gender\\|gendered\\|historicise\\|historicisation\\|historicize\\|historicization\\|hegemonic\\|hegemony\\|identity\\|identity politics\\|intensifies\\|intensify\\|intensifying\\|interrogate\\|interrogates\\|interrogation\\|intertextual\\|intertextuality\\|irony\\|ironic\\|ironical\\|ironically\\|ironisation\\|ironization\\|ironises\\|ironizes\\|jouissance\\|juxtapose\\|juxtaposes\\|juxtaposition\\|lacanian\\|lack\\|loci\\|locus\\|locuses\\|matrix\\|mise en abyme\\|mocking\\|mockingly\\|modalities\\|modality\\|myth\\|mythologies\\|mythology\\|myths\\|narrative\\|narrativisation\\|narrativization\\|narrativity\\|nexus\\|nodal\\|node\\|normative\\|normativity\\|notion\\|notions\\|objective\\|objectivity\\|objectivities\\|objet petit a\\|ontology\\|ontological\\|operate\\|operates\\|otherness\\|othering\\|paradigm\\|paradigmatic\\|paradigms\\|parody\\|parodic\\|parodies\\|physicality\\|plenitude\\|poetics\\|popular notions\\|position\\|post hoc\\|post internet\\|post-internet\\|postmodernism\\|postmodernist\\|postmodernity\\|postmodern\\|practice\\|practise\\|praxis\\|problematic\\|problematics\\|problematise\\|problematize\\|proposition\\|qua\\|reading\\|readings\\|reification\\|relation\\|relational\\|relationality\\|relations\\|representation\\|representations\\|rhizomatic\\|rhizome\\|simulacra\\|simulacral\\|simulation\\|simulationism\\|simulationism\\|situate\\|situated\\|situates\\|stereotype\\|stereotypes\\|strategy\\|strategies\\|subjective\\|subjectivity\\|subjectivities\\|subvert\\|subversion\\|subverts\\|text\\|textual\\|textuality\\|thinker\\|thinkers\\|trajectory\\|transgress\\|transgresses\\|transgression\\|transgressive\\|unfolding\\|undermine\\|undermining\\|undermines\\|work\\|works\\|wry\\|wryly\\|zizekian\\|zižekian\\)\\b")

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Highlighting
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun show-grammar-search-for-keyword (regex limit)
  "Match REGEX in buffer until LIMIT."
  (show-grammar--log "Searching for %S %S" regex limit)
  (let (match-data-to-set
	found)
    (save-match-data
      (while (and (null match-data-to-set)
		  (re-search-forward regex limit t))
	    (setq match-data-to-set (match-data))))
    (when match-data-to-set
      (set-match-data match-data-to-set)
      (goto-char (match-end 0))
      t)))

(defun show-grammar-plural-search-for-keyword (limit)
  "Highlight plurals because they often indicate vagueness."
  (interactive (list nil))
  (let (match-data)
    (setq match-data
          (save-match-data
            (catch :result
              (while (re-search-forward "\\b\\([A-Za-z]+s\\)\\b" limit t)
                (when (show-grammar-is-plural (s-downcase (substring-no-properties (match-string 1))))
                    (throw :result (match-data)))))))
    (when match-data
      (set-match-data  match-data) t)))

(defun show-grammar-is-plural (word)
  (let ((no-s (downcase (replace-regexp-in-string "s$" "" word))))
    (and
     (not (member no-s show-grammar-verb-not-noun-list))
     (or
      (member no-s show-grammar-noun-list)
      (and
       (not (s-ends-with? "ss" word))
       (not (member word show-grammar-pronoun-list))
       (not (member word show-grammar-adj-list))
       (not (member word show-grammar-verb-list))
       (not (member word show-grammar-prep-list))
       (not (member no-s show-grammar-verb-list)))))))

(setq show-grammar-verb-not-noun-list (list "churn" "addresse" "feel" "discus" "perhap" "doe" "trie"))

(setq show-grammar-pronoun-list (list "I" "me" "mine" "you" "your" "he" "him" "his" "she" "her" "her" "we" "us" "our" "they" "them" "their"))

(defun show-grammar-placeholder-search-for-keyword (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-placeholder-regex limit))

(defun show-grammar-comment-search-for-keyword (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-comment-regex limit))

(defun show-grammar-punct-search-for-keyword (limit)
  (show-grammar-search-for-keyword show-grammar-punct-regex limit))

(defun show-grammar-homophones-search-for-keyword (limit)
  (show-grammar-search-for-keyword show-grammar-homophones-regex limit))

(defun show-grammar-informal-search-for-keyword (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-informal-regex limit))
(setq show-grammar-informal-regex "\\b\\(So\\|bunch\\|whole\\|a bit\\|crazily\\|pretty\\|lots\\|typos\\|like\\)\\b")

(defun show-grammar-conjunction-search-for-keyword (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-conjunction-regex limit))
(setq show-grammar-conjunction-regex "\\b\\(because\\|and\\|or\\)\\b")

(defun show-grammar-subordinator-search-for-keyword (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-subordinator-regex limit))
(setq show-grammar-subordinator-regex "\\b\\(that\\|which\\|while\\)\\b")



(defun show-grammar-capital-search-for-keyword (limit)
  (interactive (list nil))
  ;; horrible hack - only one group matches, have this be the
  ;; first group
  (let* (
         (case-fold-search nil)
         (match (re-search-forward show-grammar-capital-regex limit t)))
    (when match
      (set-match-data (-filter (lambda (x) x )
                                 (match-data)))
      t)))

(setq show-grammar-capital-regex "\\b\\([A-H]\\|[J-Z]\\)\\|, *\\(.\\)\\|^ *\\([A-Z]\\)\\|\\. *\\([A-Z]\\)")

(defun show-grammar-quote-search-for-keyword (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-quote-regex limit))

(setq show-grammar-quote-regex "\"\\([^\"]+\\)\"")
(setq show-grammar-comment-regex ">.*")


(defun show-grammar-weasel-word-search-for-keyword (limit)
  (show-grammar-search-for-keyword show-grammar-weasel-word-regex limit))

(defun show-grammar-search-for-jargon (limit)
  (show-grammar-search-for-keyword show-grammar-jargon-regex limit))

(defun show-grammar-search-for-wrong (limit)
  (interactive (list nil))
  (show-grammar-search-for-keyword show-grammar-wrong-regex limit))

(setq show-grammar-placeholder-keyword-list
  '((show-grammar-placeholder-search-for-keyword
     (1 'show-grammar-placeholder-face t))))

(defvar show-grammar-adj-list (s-split "\n" (f-read "~/.config/emacs-show-grammar/adj.list")))
(defvar show-grammar-verb-list (append (list "was" "does" "is" "are") (s-split "\n" (f-read "~/.config/emacs-show-grammar/verb.list"))))
(defvar show-grammar-noun-list (append (list "was" "does" "is" "are") (s-split "\n" (f-read "~/.config/emacs-show-grammar/noun.list"))))
(defvar show-grammar-prep-list (list "as" "towards" "like"))

(defvar show-grammar-keywords
  '((plurals show-grammar-plural-face
            ((show-grammar-plural-search-for-keyword 0 'show-grammar-plural-face t)))
    (informal show-grammar-informal-face ((show-grammar-informal-search-for-keyword
     (0 'show-grammar-informal-face t))))
    (conjunction show-grammar-conjunction-face
                 ((show-grammar-conjunction-search-for-keyword
                    0 'show-grammar-conjunction-face t)))
    (subordinator show-grammar-subordinator-face ((show-grammar-subordinator-search-for-keyword
                                                    0 'show-grammar-subordinator-face t)))
    (punct show-grammar-punct-face ((show-grammar-punct-search-for-keyword
                                     0 'show-grammar-punct-face t)))
    (capital show-grammar-capital-face ((show-grammar-capital-search-for-keyword
     1 'show-grammar-capital-face t)))
    (quote show-grammar-quote-face ((show-grammar-quote-search-for-keyword
     0 'show-grammar-quote-face t)))
    (comment 'show-grammar-comment-face ((show-grammar-comment-search-for-keyword
     0 'show-grammar-comment-face t)))
    (homophone show-grammar-homophones-face ((show-grammar-homophones-search-for-keyword
     0 'show-grammar-homophones-face t)))
    (weasel-word show-grammar-weasel-word-face ((show-grammar-weasel-word-search-for-keyword
                                                 0 'show-grammar-weasel-word-face t)))
    (jargon show-grammar-face-jargon ((show-grammar-search-for-jargon
     0 'show-grammar-face-jargon t)) )
    (wrong show-grammar-face-wrong ((show-grammar-search-for-wrong 0 'show-grammar-face-wrong t)))))

(defun show-grammar-keywords-at-point ()
  "Find the keywords for the face at the point."
  (nth 2 (car (cl-loop for setting in show-grammar-keywords if (equal (nth 1 setting) (face-at-point)) collect setting))))

(defun show-grammar-hide-this ()
  (interactive)
  (font-lock-remove-keywords nil (show-grammar-keywords-at-point))
  (font-lock-fontify-buffer))

(defun show-grammar-only-this ()
  (interactive)
  (show-grammar-remove-keywords)
  (font-lock-add-keywords nil (show-grammar-keywords-at-point))
  (font-lock-fontify-buffer))

(defun show-grammar-everything ()
  (interactive)
  (show-grammar-remove-keywords)
  (show-grammar-add-keywords)
  (font-lock-fontify-buffer))

(defun show-grammar-add-keywords ()
  (cl-loop for setting in show-grammar-keywords do (font-lock-add-keywords nil (nth 2 setting))))

(defun show-grammar-remove-keywords ()
  (cl-loop for setting in show-grammar-keywords do (font-lock-remove-keywords nil (nth 2 setting)))
  (remove-hook 'post-command-hook (function show-grammar-post-command-hook) t))



(defun show-grammar-post-command-hook ()
  (interactive)
  (-let (
         ((start . end) (bounds-of-thing-at-point 'sentence))
         )
    (when nil (show-grammar-highlight-duplicates start end))))

(defun show-grammar-highlight-duplicates (start end &optional words)
  (when (< start end)
    (let ((word (thing-at-point 'word)))
      (save-excursion
        (goto-char start)
        (forward-thing 'word)

      (when (member word words)
        (message "word %s" word)
        (show-grammar-highlight-thing 'word 'show-grammar-duplicate-face))
      ;; N**2
      (show-grammar-highlight-duplicates (point) end (cons word words))))))

(defun show-grammar-highlight-thing (thing face)
  (-let (((start . end) (bounds-of-thing-at-point thing)))
    (set-match-data (list (copy-marker start) (copy-marker end)) )
    (font-lock-apply-highlight (list 0 (quote face)))))


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Utility macros
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defmacro interactive-optional-region ()
  "Flexible variation of (interactive \"r\").
Bind START and END parameters to either a selected region or the
entire buffer, subject to narrowing."
  `(interactive
    (if (use-region-p)
        (list (region-beginning) (region-end))
      (list (point-min) (point-max)))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Text metrics
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(defun show-grammar-count-letters (&optional start end)
  (how-many "\\w" (or start (point-min)) (or end (point-max))))

(defun show-grammar-count-syllables (&optional start end)
  ;; Naively count vowel runs as syllable markers
  (how-many "[aeiouy]+" (or start (point-min)) (or end (point-max))))

(defun show-grammar-count-words (&optional start end)
  "Count the number of words between START and END."
  (interactive-optional-region)
  (let* ((s (or start (point-min)))
         (e (or end (point-max)))
         (result
          (if (fboundp 'count-words)
              (count-words s e)
            (how-many "\\w+" s e))))
    (if (called-interactively-p 'any)
        (message "Word count: %s" result))
    result))

(defun show-grammar-count-sentences (&optional start end)
  "Count the number of words between START and END."
  (interactive-optional-region)
  (let* ((s (or start (point-min)))
         (e (or end (point-max)))
         (result
          (how-many "\\w[!?.]" s e)))
    (if (called-interactively-p 'any)
        (message "Sentence count: %s" result))
    result))

(defun show-grammar-automated-readability-index (&optional start end)
  (let ((words (float (show-grammar-count-words start end)))
        (letters (float (show-grammar-count-letters start end)))
        (sentences (float (show-grammar-count-sentences start end))))
    (if (and (> words 0) (> sentences 0))
        (- (+ (* 4.71 (/ letters words))
              (* 0.5 (/ words sentences)))
           21.43)
      0.0)))

(defun show-grammar-flesch-reading-ease (&optional start end)
  (let ((words (float (show-grammar-count-words start end)))
        (sentences (float (show-grammar-count-sentences start end))))
    (if (and (> sentences 0) (> words 0))
        (- 206.834
           (* 1.015 (/ words sentences))
           (* 84.6 (/ syllables words)))
      0.0)))

(defun show-grammar-flesch-kinkaid-grade-level (&optional start end)
  (let ((words (float (show-grammar-count-words start end)))
        (sentences (float (show-grammar-count-sentences start end)))
        (syllables (float (show-grammar-count-syllables start end))))
    (if (and (> words 0) (> sentences 0))
        (- (+ (* 11.8 (/ syllables words))
              (* 0.39 (/ words sentences)))
           15.59)
      0.0)))

(defalias 'show-grammar-word-count 'show-grammar-count-words)
(defalias 'show-grammar-sentence-count 'show-grammar-count-sentences)

(defun show-grammar-readability-index (&optional start end)
  "Determine the automated readability index between START and END."
  (interactive-optional-region)
  (message "Readability index: %s" (show-grammar-automated-readability-index start end)))

(defun show-grammar-reading-ease (&optional start end)
  "Determine the Flesch reading ease between START and END."
  (interactive-optional-region)
  (message "Reading ease: %s" (show-grammar-flesch-reading-ease start end)))

(defun show-grammar-grade-level (&optional start end)
  "Determine the Flesch-Kinkaid grade level between START and END."
  (interactive-optional-region)
  (message "Grade level: %s" (show-grammar-flesch-kinkaid-grade-level start end)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; The mode
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(setq show-grammar-mode-keymap (make-keymap))

(define-key show-grammar-mode-keymap (kbd "C-c [") 'show-grammar-word-count)
(define-key show-grammar-mode-keymap (kbd "C-c ]") 'show-grammar-sentence-count)
(define-key show-grammar-mode-keymap (kbd "C-c \\") 'show-grammar-readability-index)
(define-key show-grammar-mode-keymap (kbd "C-c /") 'show-grammar-reading-ease)
(define-key show-grammar-mode-keymap (kbd "C-c =") 'show-grammar-grade-level)

(require 'pcsv)

(defvar show-grammar-homophones-file "~/.emacs.d/external/homophone/lib/assets/homophone_list.csv")
(defvar show-grammar--homophone-list nil)

(defun show-grammar--load-homophones ()
  (when (null show-grammar--homophone-list)
      (setq show-grammar--homophone-list (pcsv-parse-file show-grammar-homophones-file))))

(defun show-grammar-homophones-show  ()
  (interactive)
  (message
   "%s"
   (s-join " " (show-grammar--homophones (thing-at-point 'word)))))


(defun show-grammar--homophones (word)
  (show-grammar--load-homophones)
  (mapcar 'show-grammar-homophone-record-spelling
          (show-grammar-homophone--get-records
           (show-grammar-homophone-record-id (show-grammar-homophone--get-record word)))))

(defun show-grammar-homophone-record-spelling (record)
  (nth 2 record))


(defun show-grammar-homophone-record-id (record)
  (nth 3 record))

(defun show-grammar-homophone--get-record (word)
  (-first (lambda (x) (equal (nth 2 x) word)) show-grammar--homophone-list ))

(defun show-grammar-homophone--get-records (id)
  (-filter (lambda (x) (equal (nth 3 x) id)) show-grammar--homophone-list ))

;;;###autoload
(define-minor-mode show-grammar-mode "Highlight passive voice, weasel words and show-grammar jargon in text, and provide useful text metrics"
  :lighter " AB"
  :keymap show-grammar-mode-keymap
  :group 'show-grammar-mode
  (if show-grammar-mode
      (progn
        (show-grammar-add-keywords)
        (font-lock-mode 1)
        (font-lock-fontify-buffer))
    (progn
      (show-grammar-remove-keywords)
      (font-lock-fontify-buffer))))

(defun show-grammar-shell (command &rest args)
  (let ((command (format command (mapcar 'shell-quote-argument args)) ))
  (assert (equal (shell-command command)  0))))
(point)

(if (not (f-exists? "~/.config/emacs-show-grammar"))
  (f-exists (show-grammar-build-wordlist)))

(defun show-grammar-build-wordlist ()
  (interactive)
  (show-grammar-shell "mkdir ~/.config/emacs-show-grammar")
  (message "Fetching wordnet data...")
  (show-grammar-shell "curl --silent http://wordnetcode.princeton.edu/wn3.1.dict.tar.gz -o ~/.config/emacs-show-grammar/data.tgz")
  (show-grammar-shell "tar -xzvf ~/.config/emacs-show-grammar/data.tgz -C ~/.config/emacs-show-grammar ")
  (show-grammar-shell "cd ~/.config/emacs-show-grammar; cat dict/data.adj | tail -n +30 | awk '{ print $5 }' > adj.list")
  (show-grammar-shell "cd ~/.config/emacs-show-grammar; cat dict/data.verb | tail -n +30 | awk '{ print $5 }' > verb.list")
  (show-grammar-shell "cd ~/.config/emacs-show-grammar; cat dict/data.adv | tail -n +30 | awk '{ print $5 }' > adv.list")
  (show-grammar-shell "cd ~/.config/emacs-show-grammar; cat dict/data.noun | tail -n +30 | awk '{ print $5 }' > noun.list"))


(defun show-grammar-info ()
  (interactive)
  (let ((face (s-join " " (butlast (nthcdr 1 (s-split "-" (format "%s" (face-at-point))))))))
    (cond
     ((equal face "homophones") (message "%s %s" face (s-join " " (show-grammar--homophones (thing-at-point 'word)))))
     ('t (message face)))))


;;; Maybe adjective phrase
;;; easy-to-protect

(provide 'show-grammar-mode)
;; TODO
;; Toggle adding word/sentence count to status bar
;; Pluralization
;; Incorporate diction commands if available (and advise on installation if not)
;; Split general writing back out

;;; show-grammar-mode.el ends here
