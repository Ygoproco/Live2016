--coded by Lyris
--Battle of Sleeping Spirits
function c511007007.initial_effect(c)
	--Activate only during the Battle Phase, if a monster(s) was destroyed by battle and sent to the Graveyard (this turn). [Rank-Up-Magic Raptor's Force] Each player can Special Summon 1 [Triggered Summon] of their monsters that was destroyed by battle this turn, [Miracle's Wake] with their effects negated. [Queen Dragun Djinn] Those monsters are destroyed at the end of the Battle Phase. [Fake Hero]
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_DESTROY+TIMING_BATTLE_END)
	e1:SetCondition(c511007007.condition)
	e1:SetOperation(c511007007.activate)
	c:RegisterEffect(e1)
	if not c511007007.globle_check then
		c511007007.globle_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c511007007.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
--Check if a monster was destroyed by battle during the turn
function c511007007.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ch=false
	while tc do
		if bit.band(tc:GetReason(),REASON_BATTLE)==REASON_BATTLE then
			ch=true
		end
		tc=eg:GetNext()
	end
	if ch then Duel.RegisterFlagEffect(0,511007007,RESET_PHASE+PHASE_END,0,1) end
end
--Is it also the Battle Phase right now?
function c511007007.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentPhase()==PHASE_BATTLE and Duel.GetFlagEffect(tp,511007007)~=0
end
function c511007007.filter(c,e,tp,tid)
	--was destroyed by battle (this turn) [Miracle's Wake]
	return c:GetTurnID()==tid and bit.band(c:GetReason(),REASON_BATTLE)~=0
		and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c511007007.activate(e,tp,eg,ep,ev,re,r,rp)
	local tid=Duel.GetTurnCount()
	--user's Summon
	if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then
		local g=Duel.GetMatchingGroup(c511007007.filter,tp,LOCATION_GRAVE,0,nil,e,tp,tid)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(511007007,0)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local tc=g:Select(tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetOperation(c511007007.endop)
			e3:SetCountLimit(1)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			tc:RegisterEffect(e3,true)
		end
	end
	--opponent's Summon
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE,1-tp)>0 then
		local g=Duel.GetMatchingGroup(c511007007.filter,1-tp,LOCATION_GRAVE,0,nil,e,1-tp,tid)
		if g:GetCount()>0 and Duel.SelectYesNo(1-tp,aux.Stringid(511007007,0)) then
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
			local tc=g:Select(1-tp,1,1,nil):GetFirst()
			Duel.SpecialSummonStep(tc,0,1-tp,1-tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(e:GetHandler())
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_DISABLE)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e1,true)
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE_EFFECT)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			tc:RegisterEffect(e2,true)
			local e3=Effect.CreateEffect(e:GetHandler())
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetCode(EVENT_PHASE+PHASE_BATTLE)
			e3:SetRange(LOCATION_MZONE)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetOperation(c511007007.endop)
			e3:SetCountLimit(1)
			e3:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_BATTLE)
			tc:RegisterEffect(e3,true)
		end
	end
	Duel.SpecialSummonComplete()
end
function c511007007.endop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
