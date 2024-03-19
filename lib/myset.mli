module type ElementSet = sig
  type t
  (** type t is the type of the elements of the set. *)

  val compare : t -> t -> int
  (** [compare] two elements of the type t [x], [y] and return an int [result]
      according to the comparison. *)

  val to_string : t -> string
  (** [to_string] converts [t] to a string. *)
end

module type MySet = sig
  type element
  (** type element is the type of the elements of the set. *)

  type t
  (** t is the type of set. *)

  val empty : t
  (** [empty] creates an empty set of type t. *)

  val add : element -> t -> t
  (** [add x s] is the set containing all the elements of [s] as well as [x]. OP
      6.3*)

  val to_string : t -> string
  (** [to_string] converts [t] to a string. *)

  val intersection : t -> t -> t
  (** [intersection s1 s2] is the set containing all the elements that are in
      both [s1] and [s2]. (OP 6.3)*)
end

(** Abstraction function: The list [[a1; ...; an]] represents the set
    [{b1, ..., bm}], where [[b1; ...; bm]] is the same list as [[a1; ...; an]]
    but with any duplicates removed. The empty list [[]] represents the empty
    set [{}]. (OP 6.3)*)
module Make (E : ElementSet) : MySet with type element = E.t
