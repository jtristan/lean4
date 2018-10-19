/*
Copyright (c) 2015 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Leonardo de Moura
*/
#include "library/compiler/simp_inductive.h"
#include "library/compiler/util.h"
#include "library/compiler/lcnf.h"
#include "library/compiler/elim_dead_let.h"
#include "library/compiler/cse.h"
#include "library/compiler/specialize.h"
#include "library/compiler/extract_closed.h"
#include "library/compiler/compiler.h"

namespace lean {
void initialize_compiler_module() {
    initialize_simp_inductive();
    initialize_compiler_util();
    initialize_lcnf();
    initialize_elim_dead_let();
    initialize_cse();
    initialize_specialize();
    initialize_extract_closed();
    initialize_compiler();
}

void finalize_compiler_module() {
    finalize_compiler();
    finalize_extract_closed();
    finalize_specialize();
    finalize_cse();
    finalize_elim_dead_let();
    finalize_lcnf();
    finalize_compiler_util();
    finalize_simp_inductive();
}
}
