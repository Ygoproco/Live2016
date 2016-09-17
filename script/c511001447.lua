--Session Draw
function c511001447.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)	
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c511001447.activate)
	c:RegisterEffect(e1)
end
function c511001447.activate(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_DRAW)	
	e1:SetCountLimit(1)
	if Duel.GetTurnPlayer()==tp and ph==PHASE_DRAW then
		e1:SetLabel(Duel.GetTurnCount())
		e1:SetCondition(c511001447.con)
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,2)
	else
		e1:SetReset(RESET_PHASE+PHASE_DRAW+RESET_SELF_TURN,1)
	end
	e1:SetOperation(c511001447.op)
	Duel.RegisterEffect(e1,tp)
end
function c511001447.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnCount()~=e:GetLabel()
end
function c511001447.xyzfilter(c,mg)
	if c.xyz_count~=2 then return false end
	return c:IsXyzSummonable(mg)
end
function c511001447.op(e,tp,eg,ep,ev,re,r,rp)
	if ep~=tp or Duel.GetCurrentPhase()~=PHASE_DRAW or Duel.GetTurnPlayer()~=tp 
		or bit.band(r,REASON_RULE)==0 then return end
	Duel.Hint(HINT_CARD,0,511001447)
	local tc1=eg:GetFirst()
	local tc2=Duel.GetDecktopGroup(tp,1):GetFirst()
	Duel.Draw(tp,1,REASON_EFFECT)
	if tc1 and tc2 then
		local g=Group.FromCards(tc1,tc2)
		Duel.ConfirmCards(1-tp,g)
		if tc1:IsType(TYPE_MONSTER) and tc2:IsType(TYPE_MONSTER) and tc1:GetLevel()==tc2:GetLevel() then
			local xyzg=Duel.GetMatchingGroup(c511001447.xyzfilter,tp,LOCATION_EXTRA,0,nil,g)
			if xyzg:GetCount()>0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local xyz=xyzg:Select(tp,1,1,nil):GetFirst()
				xyz:SetMaterial(g)
				Duel.Overlay(xyz,g)
				Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,true,false,POS_FACEUP)
				xyz:CompleteProcedure()
			end
		end
		Duel.ShuffleHand(tp)
	end
	Duel.ShuffleHand(tp)
end
