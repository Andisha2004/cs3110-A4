module type ElementSet = sig
  type t

  val compare : t -> t -> int
  val to_string : t -> string
end

module type MySet = sig
  type element
  type t

  val empty : t
  val add : element -> t -> t
  val to_string : t -> string
  val intersection : t -> t -> t
end

module Make (E : ElementSet) : MySet with type element = E.t = struct
  type element = E.t
  type t = element list

  let empty = []

  let rec add x = function
    | [] -> [ x ]
    | h :: t -> (
        match E.compare x h with
        | 0 -> h :: t (* x is already in the set; return the list as is. *)
        | n when n < 0 ->
            x :: h :: t (* Insert x before h since x is smaller. *)
        | _ -> h :: add x t (* Continue with the rest of the list. *))

  let to_string set =
    let sorted_list = List.sort E.compare set in
    let string_elements = List.map E.to_string sorted_list in
    "{" ^ String.concat ", " string_elements ^ "}"

  let intersection set1 set2 =
    let rec intersect acc list1 list2 =
      match (list1, list2) with
      | [], _
      | _, [] ->
          List.rev acc
      | head1 :: tail1, head2 :: tail2 -> (
          match E.compare head1 head2 with
          | 0 -> intersect (head1 :: acc) tail1 tail2
          | n when n < 0 -> intersect acc tail1 list2
          | _ -> intersect acc list1 tail2)
    in
    intersect [] set1 set2
end
