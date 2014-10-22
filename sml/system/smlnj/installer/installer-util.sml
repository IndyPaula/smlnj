(* installer-util.sml
 *
 * Utility routines used both by the main installer
 * and the library installer
 *
 * (C) 2007 The Fellowship of SML/NJ
 *
 * author: Matthias Blume
 *)
structure InstallerUtil : sig

    val say : string list -> unit
    val warn : string list -> unit
    val fail : string list -> 'a

    val platformInfo : unit -> { arch_oskind : string,
				 heap_suffix : string,
				 isUnix : bool }

    val pconcat : string list -> string

    val fexists : string -> bool
    val rmfile : string -> unit
    val mkdir : string -> unit
    val rename : { old : string, new : string } -> unit

end = struct

    structure P = OS.Path
    structure F = OS.FileSys
    structure SI = SMLofNJ.SysInfo

    fun say l = TextIO.output (TextIO.stdErr, concat l)
    fun warn l = say ("WARNING: " :: l)
    fun fail l = (say ("FAILURE: " :: l);
		  OS.Process.exit OS.Process.failure)

    (* figure out who and what we are *)
    fun platformInfo () =
	let val arch = String.map Char.toLower (SI.getHostArch ())
	    val (isUnix, oskind) = case SI.getOSKind () of
				       SI.UNIX => (true, "unix")
				     | SI.WIN32 => (false, "win32")
				     | _ => fail ["os kind not supported\n"]
	in { arch_oskind = concat [arch, "-", oskind],
	     heap_suffix = SI.getHeapSuffix (),
	     isUnix = isUnix }
	end

    fun fexists f = F.access (f, []) handle _ => false
    fun rmfile f = F.remove f handle _ => ()

    (* make a directory (including parent, parent's parent, ...) *)
    fun mkdir "" = ()
      | mkdir d = if fexists d then () else (mkdir (P.dir d); F.mkDir d)

    (* generalized F.rename that works across different file systems *)
    fun rename { old, new } =
	let fun copy () =
		let val ins = BinIO.openIn old
		    val outs = BinIO.openOut new
		    fun loop () =
			let val v = BinIO.input ins
			in if Word8Vector.length v = 0 then
			       (BinIO.closeIn ins; BinIO.closeOut outs)
			   else (BinIO.output (outs, v); loop ())
			end
		in loop ()
		end
	in F.rename { old = old, new = new }
	   handle _ =>
		  (* probably on different filesys *)
		  (copy (); rmfile old)
	end

    fun pconcat [] = ""
      | pconcat [p] = p
      | pconcat (p :: ps) = P.concat (p, pconcat ps)
end