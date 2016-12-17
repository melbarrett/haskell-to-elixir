defmodule TCOM do
  require FSynF
  import Model

  #Quantifiers
  def allNum(m, n), do: m == 0
  def noNum(m, n), do: n == 0
  def atleastNum(k, m, n), do: n >= k
  def atmostNum(k, m, n), do: n <= k
  def atleast2butnotall(m, n), do: m > 0 and n>=2

  def rel3(w, x, y) do
    if (w == dorothy.entity or w == dorothy) do love(x,y)
    else if (w == :E) do !love(x,y)
    else false end end
  end

  #Example sentences, run by calling:
  #TCOM.intSent(TCOM.sent1)
  #The dwarf B loves snowWhite
  def sent1 do
    sent1 = %FSynF.Sentence{np: %FSynF.NP{det: :the, cn: :B},
            vp: %FSynF.VP{tv: &Model.love/2, np: %FSynF.NP{cn: :S}}}
  end
  #The giant T gives snowWhite a dagger.
  def sent2 do
    sent2 = %FSynF.Sentence{np: %FSynF.NP{det: :the, cn: :T},
            vp: %FSynF.VP{dv: &Model.give/3, np: %FSynF.NP{cn: :S},
            np1: %FSynF.NP{cn: :X}}}
  end
  #The dwarf B that loved snowWhite loved snowWhite
  def sent3 do
    sent3 = %FSynF.Sentence{np: %FSynF.NP{det: :the, rcn:
      %FSynF.RCN{cn: :B, vp: %FSynF.VP{tv: &Model.love/2, np: %FSynF.NP{cn: :S}}}},
      vp: %FSynF.VP{tv: &Model.love/2, np: %FSynF.NP{cn: :S}}}
  end

  #function which breaks down sentencese into vp, np
  def intSent(sent) do
    if(sent.np.rcn != nil) do intNP(sent.np.rcn) and intVP(sent.vp, sent.np.rcn)
    else intNP(sent.np) and intVP(sent.vp, sent.np) end
  end

  #breaks down np into det & cn, or det and rcn
  def intNP(np) do
    if(child(np)) do true end
    if np.cn != nil do intDET(np.det) and intCN(np.cn)
    else if np.rcn.vp != nil do
      intRCN(np.rcn.cn, np.rcn.that, np.rcn.vp)
    else intRCN(np.rcn.cn, np.rcn.that, np.rcn.np, np.rcn.tv) end end
  end

  #returns true if the cn is a cn
  def intCN(cn) do
    girl(cn) or boy(cn) or princess(cn) or dwarf(cn)
    or giant(cn) or wizard(cn) or sword(cn) or dagger(cn)
  end

  #breaks relative clause noun into its own vp
  def intRCN(cn, that, vp) do
    intVP(vp, cn)
  end
  def intRCN(cn, that, np, tv) do
    intVP(tv, cn, np.cn)
  end

  #returns true if :det == to any of these
  def intDET(det) do
    det == :the or det == :every or det == :some
    or det == :no or det == :most or det == nil
  end

  #returns true if vp passed into a OPP returns true
  #or calls intVP/3 or intVP/4 if vp is 2PP or 3PP
  def intVP(vp, n) do
    if(laugh(vp) or cheer(vp) or shudder(vp)) do true end
    if vp.tv != nil do intVP(vp.tv, n.cn, vp.np.cn)
    else intVP(vp.dv, n.cn, vp.np.cn, vp.np1.cn) end
  end
  #2PP verb phrases, calls the trasitive verb function passing in subj and obj
  def intVP(tv, subj, obj) do
    tv.(subj,obj)
  end
  #3pp verb phrases, calls the ditranstive-verb function passing in
  #subj, direct object, and indirect object
  def intVP(dv, subj, dobj, iobj) do
    dv.(subj, dobj, iobj)
  end

end
