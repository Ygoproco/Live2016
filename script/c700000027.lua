--Scripted by Eerie Code
--Raidraptor - Satellite Cannon Falcon
function c700000027.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_WINDBEAST),8,2)
	c:EnableReviveLimit()
	--Reduce ATK
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(c700000027.cost)
	e1:SetTarget(c700000027.target)
	e1:SetOperation(c700000027.operation)
	c:RegisterEffect(e1)
end

function c700000027.cost(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function c700000027.target(e,tp,ep,eg,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) and Duel.IsExistingMatchingCard(Card.IsSetCard,tp,LOCATION_GRAVE,0,1,nil,0xba) end
end
function c700000027.operation(e,tp,ep,eg,ev,re,r,rp)
	local mg=Duel.GetMatchingGroupCount(c700000027.filter1,tp,0,LOCATION_MZONE,nil)
	local rc=Duel.GetMatchingGroupCount(Card.IsSetCard,tp,LOCATION_GRAVE,0,nil,0xba)
	if mg==0 or rc==0 then return end
	local b=true
	while rc>0 and b and Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) do
		local tg=Duel.SelectMatchingCard(tp,aux.nzatk,tp,0,LOCATION_MZONE,1,1,nil)
		local tc=tg:GetFirst()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(-800)
		e1:SetReset(RESET_EVENT+0x1ff0000)
		tc:RegisterEffect(e1)
		rc=rc-1
		if rc>0 and Duel.IsExistingMatchingCard(aux.nzatk,tp,0,LOCATION_MZONE,1,nil) then b=Duel.SelectYesNo(tp,aux.Stringid(6528,8)) end
	end
end