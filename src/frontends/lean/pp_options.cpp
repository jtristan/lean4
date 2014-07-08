/*
Copyright (c) 2014 Microsoft Corporation. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.

Author: Leonardo de Moura
*/
#include "frontends/lean/pp_options.h"

#ifndef LEAN_DEFAULT_PP_MAX_DEPTH
#define LEAN_DEFAULT_PP_MAX_DEPTH std::numeric_limits<unsigned>::max()
#endif

#ifndef LEAN_DEFAULT_PP_MAX_STEPS
#define LEAN_DEFAULT_PP_MAX_STEPS std::numeric_limits<unsigned>::max()
#endif

#ifndef LEAN_DEFAULT_PP_NOTATION
#define LEAN_DEFAULT_PP_NOTATION true
#endif

#ifndef LEAN_DEFAULT_PP_IMPLICIT
#define LEAN_DEFAULT_PP_IMPLICIT false
#endif

#ifndef LEAN_DEFAULT_PP_COERCION
#define LEAN_DEFAULT_PP_COERCION false
#endif

#ifndef LEAN_DEFAULT_PP_EXTRA_LETS
#define LEAN_DEFAULT_PP_EXTRA_LETS true
#endif

#ifndef LEAN_DEFAULT_PP_ALIAS_MIN_WEIGHT
#define LEAN_DEFAULT_PP_ALIAS_MIN_WEIGHT 20
#endif

namespace lean {
static name g_pp_max_depth        {"lean", "pp", "max_depth"};
static name g_pp_max_steps        {"lean", "pp", "max_steps"};
static name g_pp_notation         {"lean", "pp", "notation"};
static name g_pp_implicit         {"lean", "pp", "implicit"};
static name g_pp_coercion         {"lean", "pp", "coercion"};
static name g_pp_extra_lets       {"lean", "pp", "extra_lets"};
static name g_pp_alias_min_weight {"lean", "pp", "alias_min_weight"};

RegisterUnsignedOption(g_pp_max_depth, LEAN_DEFAULT_PP_MAX_DEPTH,
                       "(lean pretty printer) maximum expression depth, after that it will use ellipsis");
RegisterUnsignedOption(g_pp_max_steps, LEAN_DEFAULT_PP_MAX_STEPS,
                       "(lean pretty printer) maximum number of visited expressions, after that it will use ellipsis");
RegisterBoolOption(g_pp_notation,  LEAN_DEFAULT_PP_NOTATION,
                   "(lean pretty printer) disable/enable notation (infix, mixfix, postfix operators and unicode characters)");
RegisterBoolOption(g_pp_implicit,  LEAN_DEFAULT_PP_IMPLICIT,
                   "(lean pretty printer) display implicit parameters");
RegisterBoolOption(g_pp_coercion,  LEAN_DEFAULT_PP_COERCION,
                   "(lean pretty printer) display coercions");
RegisterBoolOption(g_pp_extra_lets,  LEAN_DEFAULT_PP_EXTRA_LETS,
                   "(lean pretty printer) introduce extra let expressions when displaying shared terms");
RegisterUnsignedOption(g_pp_alias_min_weight,  LEAN_DEFAULT_PP_ALIAS_MIN_WEIGHT,
                       "(lean pretty printer) mimimal weight (approx. size) of a term to be considered a shared term");

unsigned get_pp_max_depth(options const & opts)        { return opts.get_unsigned(g_pp_max_depth, LEAN_DEFAULT_PP_MAX_DEPTH); }
unsigned get_pp_max_steps(options const & opts)        { return opts.get_unsigned(g_pp_max_steps, LEAN_DEFAULT_PP_MAX_STEPS); }
bool     get_pp_notation(options const & opts)         { return opts.get_bool(g_pp_notation, LEAN_DEFAULT_PP_NOTATION); }
bool     get_pp_implicit(options const & opts)         { return opts.get_bool(g_pp_implicit, LEAN_DEFAULT_PP_IMPLICIT); }
bool     get_pp_coercion(options const & opts)         { return opts.get_bool(g_pp_coercion, LEAN_DEFAULT_PP_COERCION); }
bool     get_pp_extra_lets(options const & opts)       { return opts.get_bool(g_pp_extra_lets, LEAN_DEFAULT_PP_EXTRA_LETS); }
unsigned get_pp_alias_min_weight(options const & opts) { return opts.get_unsigned(g_pp_alias_min_weight, LEAN_DEFAULT_PP_ALIAS_MIN_WEIGHT); }
}
