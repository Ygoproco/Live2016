--SRアクマグネ
--Speedroid Fiendmagnet
--Scripted by Eerie Code
--fixed by MLD
function c62899696.initial_effect(c)
	--cannot be synchro
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCondition(c62899696.syncon)
	e1:SetValue(c62899696.synlimit)
	c:RegisterEffect(e1)
	--material check
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetCondition(c62899696.spcon)
	e2:SetTarget(c62899696.sptg)
	e2:SetOperation(c62899696.spop)
	e2:SetCountLimit(1,62899696)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
end
function c62899696.syncon(e)
	return e:GetHandler():GetFlagEffect(62899696)==0
end
function c62899696.synlimit(e,c)
	if not c then return false end
	return true
end
function c62899696.spcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return Duel.GetTurnPlayer()==tp and (ph==PHASE_MAIN1 or ph==PHASE_MAIN2)
end
function c62899696.filter(c,tp,tc)
	return c:IsFaceup() and Duel.IsExistingMatchingCard(c62899696.synfilter,tp,LOCATION_EXTRA,0,1,nil,tc,c)
end
function c62899696.synfilter(sc,c,tc)
	local temp=false
	if not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
		e1:SetReset(RESET_CHAIN)
		tc:RegisterEffect(e1)
		temp=true
	end
	c:RegisterFlagEffect(62899696,RESET_CHAIN,0,1)
	local g=Group.FromCards(c,tc)
	local res=sc:IsAttribute(ATTRIBUTE_WIND) and sc:IsSynchroSummonable(nil,g)
	if temp then tc:ResetEffect(EFFECT_SYNCHRO_MATERIAL,RESET_CODE) end
	c:ResetFlagEffect(62899696)
	return res
end
function c62899696.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(1-tp) and c62899696.filter(chkc,tp,c) end
	if chk==0 then return Duel.IsExistingTarget(c62899696.filter,tp,0,LOCATION_MZONE,1,nil,tp,c) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	Duel.SelectTarget(tp,c62899696.filter,tp,0,LOCATION_MZONE,1,1,nil,tp,c)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c62899696.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc and tc:IsRelateToEffect(e) then
		if not tc:IsHasEffect(EFFECT_SYNCHRO_MATERIAL) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_SYNCHRO_MATERIAL)
			e1:SetReset(RESET_CHAIN)
			tc:RegisterEffect(e1)
		end
		c:RegisterFlagEffect(62899696,RESET_CHAIN,0,1)
		local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
		if g:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SynchroSummon(tp,sg:GetFirst(),nil,Group.FromCards(c,tc))
		end
	end
end
