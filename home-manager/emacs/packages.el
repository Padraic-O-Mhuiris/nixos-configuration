(package! code-review :recipe (:files ("graphql" "code-review*.el"))
  :pin "26f426e99221a1f9356aabf874513e9105b68140")
    ; HACK closql c3b34a6 breaks code-review wandersoncferreira/code-review#245,
    ; and the current forge commit (but forge does have an upstream fix),
    ; pinned as a temporary measure to prevent user breakages
(package! closql :pin "0a7226331ff1f96142199915c0ac7940bac4afdd")
