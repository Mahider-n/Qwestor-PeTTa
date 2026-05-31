!(import! &self ../../utils/utils)
!(import! &self ../appraisal)

!(import! &self ../routing)
 
!(bind! &guard-space (new-space))

!(add-atom &guard-space (decompose_min_complexity 0.40))
!(add-atom &guard-space (decompose_urgent_min_complexity 0.70))
!(add-atom &guard-space (decompose_max_ambiguity 0.80))
!(add-atom &guard-space (help_short 0.60))
!(add-atom &guard-space (
         modulator-vector
        (m_urgency           0.20)
        (m_resolution        0.40)
        (m_user_expertise    0.50)
        (m_threshold         0.30)
        (m_topic_familiarity 0.50)
        (m_failure_wariness  0.10)
        (m_securing          0.10)
        (m_approach          0.40)
        (m_arousal           0.40)
        (m_risk_aversion     0.40)
        (m_error_tolerance   0.45)
        (m_creativity        0.45)
        (m_valence           0.00)
)) 
; test-case for get-action-score
!(test
  (get-action-score ((act_search 10) (act_decompose 5)) act_search)
  10
)

!(test
  (get-action-score ((act_search 10) (act_decompose 5)) act_decompose)
  5
)

!(test
  (get-action-score ((act_search 10) (act_decompose 5)) act_verify)
  (ACTION_BLOCKED_SCORE)
)

!(test
  (get-action-score () act_search)
  (ACTION_BLOCKED_SCORE)
)

; test-case for set-action-score
!(test
  (set-action-score ((act_search 10) (act_decompose 5))
                    act_search
                    15)
  ((act_search 15) (act_decompose 5))
)

!(test
  (set-action-score ((act_search 10) (act_decompose 5))
                    act_decompose
                    7)
  ((act_search 10) (act_decompose 7))
)

!(test
  (set-action-score ()
                    act_search
                    10)
  ((act_search 10))
)
 
; test-case for adjust-action-score
!(test
  (adjust-action-score ((act_search 10) (act_decompose 5))
                       act_search
                       3)
  ((act_search 13) (act_decompose 5))
)

!(test
  (adjust-action-score ((act_search 10) (act_decompose 5))
                       act_decompose
                       -2)
  ((act_search 10) (act_decompose 3))
)

!(test
  (adjust-action-score ((act_search 10))
                       act_verify
                       5)
  ((act_search 10))
)
; test-case for get-context-value
!(test (ctx-val () act-search) 0.0)
!(test (ctx-val ((act-search 10) (act-attack 5)) act-search) 10)
!(test (ctx-val ((act-search 10) (act-attack 5)) act-attack) 5)
!(test (ctx-val ((act-search 10) (act-attack 5)) act-defend) 0.0)
!(test (ctx-val ((act-search 10) (act-search 20)) act-search) 10)   


; test-case for guard-decompose
 
!(test
  (guard-decompose ((act_decompose 10.0)) ((complexity 0.20) (ambiguity 0.10) (urgent_flag false)) &guard-space)
  ((act_decompose (ACTION_BLOCKED_SCORE)))
)

!(test
  (guard-decompose ((act_decompose 10.0)) ((complexity 0.60) (ambiguity 0.10) (urgent_flag false) (needs_task_plan 0.30) (reflective_intent 0.10)) &guard-space)
  ((act_decompose (ACTION_BLOCKED_SCORE)))
)

!(test
  (guard-decompose ((act_decompose 10.0)) ((complexity 0.60) (ambiguity 0.10) (urgent_flag false) (needs_task_plan 0.70) (reflective_intent 0.80) (needs_external_evidence 0.20)) &guard-space)
  ((act_decompose 10.10))
)

!(test
  (guard-decompose ((act_decompose 10.0)) ((complexity 0.20) (ambiguity 0.10) (urgent_flag false)) &guard-space)
  ((act_decompose (ACTION_BLOCKED_SCORE)))
)

!(test
  (guard-decompose ((act_decompose 10.0)) ((complexity 0.60) (ambiguity 0.10) (urgent_flag false) (needs_task_plan 0.30) (reflective_intent 0.10)) &guard-space)
  ((act_decompose (ACTION_BLOCKED_SCORE)))
)

; test-case for guard-search-synth
!(test
  (guard-search-synth ((act_search 10.0) (act_synthesize 5.0)) ((needs_external_evidence 0.70) (needs_task_plan 0.50) (needs_multi_source_integration 0.80) (verify_request 0)))
  ((act_search 10.30) (act_synthesize 5.20))
)

!(test
  (guard-search-synth ((act_search 10.0) (act_synthesize 5.0)) ((needs_external_evidence 0.10) (needs_task_plan 0.20) (needs_multi_source_integration 0.30) (verify_request 0)))
  ((act_search 9.82) (act_synthesize (ACTION_BLOCKED_SCORE)))
)

!(test
  (guard-search-arb ((act_search 10.0) (act_decompose 10.0) (act_synthesize 5.0)) ((needs_external_evidence 0.85) (needs_task_plan 0.50) (needs_multi_source_integration 0.80)))
  ((act_search 10.26) (act_decompose 9.74) (act_synthesize 4.88))
)

!(test
  (guard-search-arb ((act_search 10.0) (act_decompose 10.0) (act_synthesize 5.0)) ((needs_external_evidence 0.30) (needs_task_plan 0.80) (needs_multi_source_integration 0.40)))
  ((act_search 9.88) (act_decompose 10.18) (act_synthesize 4.90))
)
