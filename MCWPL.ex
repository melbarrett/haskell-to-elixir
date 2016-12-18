defmodule MCWPL do
  import FSynF
  import Model

  #logical form structure
  defmodule LF do
    defstruct [:term]
  end

  #np implemented for testing
  def np1 do
    np1 = %FSynF.NP{det: :the, cn: :B}
  end

  #Sentences for testing
  #Call: MCWPL.lfSent(MCWPL.sent3)
  #The dwarf B loves snow white
  def sent1 do
    sent1 = %FSynF.Sentence{np: %FSynF.NP{det: :the, cn: :B},
            vp: %FSynF.VP{tv: :love, np: %FSynF.NP{cn: :S}}}
  end
  #The giant T gives snow white a dagger
  def sent2 do
    sent2 = %FSynF.Sentence{np: %FSynF.NP{det: :the, cn: :T},
            vp: %FSynF.VP{dv: :give, np: %FSynF.NP{cn: :S},
            np1: %FSynF.NP{det: :a, cn: :X}}}
  end
  #The dwarf b that loves snow white loves snow white
  def sent3 do
    sent3 = %FSynF.Sentence{np: %FSynF.NP{det: :the, rcn:
      %FSynF.RCN{cn: :B, vp: %FSynF.VP{tv: :love, np: %FSynF.NP{cn: :S}}}},
      vp: %FSynF.VP{tv: :love, np: %FSynF.NP{cn: :S}}}
  end

  #Finds lf of sentences
  def lfSent(sent) do
    n = lfNP(sent.np)
    v = lfVP(sent.vp, sent.np)
    %LF{term: [n.term] ++ [v.term]}
  end

  #Finds lf of NPs
  def lfNP(np) do
    if np.det != nil do detV = lfDET(np.det) else detV = %LF{term: ""} end
    if(np.cn != nil) do cnV = lfCN(np.cn)
    l = [detV.term] ++ [cnV.term]
    %LF{term: l} else
    if(np.rcn != nil) do
      rcnV = lfRCN(np.rcn)
      l = [detV.term] ++ [rcnV.term]
      %LF{term: l}
    end end
  end

  #Returns cn in lf
  def lfCN(cn) do
    %LF{term: cn}
  end

  #Returns cn that v's in lf
  def lfRCN(rcn) do
    cn = lfCN(rcn.cn)
    cn = cn.term
    v = lfVP(rcn.vp, rcn)
    v = v.term
    %LF{term: [cn] ++ [:that] ++ [v]}
  end

  #returns det in lf
  def lfDET(det) do
    %LF{term: det}
  end

  #returns vp in lf
  def lfVP(vp, n) do
    if(vp.tv != nil) do
      subj = lfNP(n)
      subj = subj.term
      obj = lfNP(vp.np)
      obj = obj.term
      tv = lfTV(vp.tv, {subj,obj})
      %LF{term: tv.term}
    else if(vp.dv != nil) do
      subj = lfNP(n)
      subj = subj.term
      dobj = lfNP(vp.np)
      dobj = dobj.term
      iobj = lfNP(vp.np1)
      iobj = iobj.term
      dv = lfDV(vp.dv, {subj, iobj, dobj})
      %LF{term: dv.term}
    end end
  end

  #returns verbs object in lf
  def lfTV(tv, {subj, obj}) do
    %LF{term: [tv] ++ [obj]}
  end

  #returns verbs direct, indirect object in lf
  def lfDV(dv, {subj, iobj, dobj}) do
    %LF{term: [dv] ++ [{dobj, iobj}]}
  end


end
