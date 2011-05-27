(***********************************************************************)
(*                                                                     *)
(*                           Objective Caml                            *)
(*                                                                     *)
(*            Xavier Leroy, projet Cristal, INRIA Rocquencourt         *)
(*                                                                     *)
(*  Copyright 1996 Institut National de Recherche en Informatique et   *)
(*  en Automatique.  All rights reserved.  This file is distributed    *)
(*  under the terms of the Q Public License version 1.0.               *)
(*                                                                     *)
(***********************************************************************)

(* $Id$ *)

(* Type-checking of the module language *)

open Types
open Format

val type_module:
        Env.t -> Parsetree.module_expr -> Typedtree.module_expr
val type_structure:
        Env.t -> Parsetree.structure -> Location.t ->
          Typedtree.structure * signature * Env.t
val type_implementation:
        string -> string -> string -> Env.t -> Parsetree.structure ->
                               Typedtree.structure * Typedtree.module_coercion
val transl_signature:
        Env.t -> Parsetree.signature -> signature
val check_nongen_schemes:
        Env.t -> Typedtree.structure -> unit

val simplify_signature: signature -> signature

val package_interfaces:
  (* objfiles *) string list -> (* target *) string -> (* pack_functor *) string option -> unit

val package_units:
  string list -> string -> string -> Ident.t option ->
    Typedtree.module_coercion * (Ident.t * Ident.t) option * (string * Digest.t) list

val print_types : formatter -> string -> unit

type error =
    Cannot_apply of module_type
  | Not_included of Includemod.error list
  | Cannot_eliminate_dependency of module_type
  | Signature_expected
  | Structure_expected of module_type
  | With_no_component of Longident.t
  | With_mismatch of Longident.t * Includemod.error list
  | Repeated_name of string * string
  | Non_generalizable of type_expr
  | Non_generalizable_class of Ident.t * class_declaration
  | Non_generalizable_module of module_type
  | Implementation_is_required of string
  | Interface_not_compiled of string
  | Not_allowed_in_functor_body
  | With_need_typeconstr
  | Not_a_packed_module of type_expr
  | Incomplete_packed_module of type_expr
  | Inconsistent_functor_arguments of string * string
  | No_functor_argument
  | Functor_argument_not_found of string
  | File_not_found of string

exception Error of Location.t * error

val report_error: formatter -> error -> unit
