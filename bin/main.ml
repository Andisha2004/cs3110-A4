(* @author: Andisha Safdariyan (as3254) *)
open Myset
open Batteries

(* Reads all lines from the given file using Batteries' BatFile.lines_of *)
let read_file filename = BatList.of_enum (BatFile.lines_of filename)

let () =
  (* Check if the -i flag is present for case-insensitive comparison *)
  let case_insensitive, args_offset =
    if Array.length Sys.argv >= 4 && Sys.argv.(1) = "-i" then (true, 2)
    else (false, 1)
  in

  if Array.length Sys.argv < args_offset + 2 then
    Printf.printf "Usage: %s [-i] <filename1> <filename2>\n" Sys.argv.(0)
  else
    let filename1 = Sys.argv.(args_offset) in
    let filename2 = Sys.argv.(args_offset + 1) in

    (* Select the appropriate comparison function based on case sensitivity *)
    let compare_fun =
      if case_insensitive then fun x y ->
        String.compare (String.lowercase_ascii x) (String.lowercase_ascii y)
      else String.compare
    in

    (* Define a module for strings with the selected comparison function *)
    let module StringElement = struct
      type t = string

      let compare = compare_fun
      let to_string s = s
    end in
    (* Create a set module using the functor with the defined StringElement
       module *)
    let module StringSet = Make (StringElement) in
    (* Read files and construct sets *)
    let lines1 = read_file filename1 in
    let lines2 = read_file filename2 in
    let set1 =
      List.fold_left
        (fun acc elem -> StringSet.add elem acc)
        StringSet.empty lines1
    in
    let set2 =
      List.fold_left
        (fun acc elem -> StringSet.add elem acc)
        StringSet.empty lines2
    in

    (* Find the intersection of the two sets *)
    let intersection_set = StringSet.intersection set1 set2 in

    (* Convert the resulting set to a string and print it *)
    print_endline (StringSet.to_string intersection_set)
