--天地開闢
--Universal Beginning
--Scripted by Eerie Code
function c32360466.initial_effect(c)
	--
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,32360466+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c32360466.tg)
	e1:SetOperation(c32360466.op)
	c:RegisterEffect(e1)
end

function c32360466.fil(c)
	return c:IsRace(RACE_WARRIOR) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c32360466.bgfil(c)
	return c:IsSetCard(0x10cf) or c:IsSetCard(0xbd)
end
function c32360466.gfil(c,tp)
	return c32360466.fil(c) and c32360466.bgfil(c) and Duel.IsExistingMatchingCard(c32360466.fil,tp,LOCATION_DECK,0,2,c)
end
function c32360466.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c32360466.gfil,tp,LOCATION_DECK,0,1,nil,tp) end
end
function c32360466.op(e,tp,eg,ep,ev,re,r,rp)
	local dg=Duel.GetMatchingGroup(c32360466.gfil,tp,LOCATION_DECK,0,nil,tp)
	if dg:GetCount()==0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local bgc=dg:Select(tp,1,1,nil):GetFirst()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONFIRM)
	local sg=Duel.SelectMatchingCard(tp,c32360466.fil,tp,LOCATION_DECK,0,2,2,bgc)
	sg:AddCard(bgc)
	Duel.ConfirmCards(1-tp,sg)
	Duel.ShuffleDeck(tp)
	local tg=sg:Select(1-tp,1,1,nil)
	local tc=tg:GetFirst()
	Duel.Hint(HINT_CARD,0,tc:GetCode())
	if c32360466.bgfil(tc) and tc:IsAbleToHand() then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		sg:RemoveCard(tc)
	end
	Duel.SendtoGrave(sg,REASON_EFFECT)
end