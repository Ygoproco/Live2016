--天地開闢
--Universal Beginning
--Scripted by Eerie Code
function c7585.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,7585+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c7585.tg)
	e1:SetOperation(c7585.op)
	c:RegisterEffect(e1)
end

function c7585.fil(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c7585.bgfil(c)
	return c:IsSetCard(0x10cf) or c:IsSetCard(0xbd)
end
function c7585.gfil(c,tp)
	return c7585.fil(c) and c7585.bgfil(c) and Duel.IsExistingMatchingCard(c7585.fil,tp,LOCATION_DECK,0,2,c)
end
function c7585.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c7585.gfil,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c7585.op(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c7585.gfil,tp,LOCATION_DECK,0,nil,tp)
	if dg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local bgc=dg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,c7585.fil,tp,LOCATION_DECK,0,2,2,bgc)
	sg:AddCard(bgc)
	Duel.ConfirmCards(1-tp,sg)
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_CONFIRM)
	local tg=sg:Select(1-tp,1,1,nil)
	if tg:IsExists(c7585.bgfil,1,nil) then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
		sg:RemoveCard(tg:GetFirst())
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end