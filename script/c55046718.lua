--ヴァイロン・コンポーネント
function c55046718.initial_effect(c)
	aux.AddEquipProcedure(c,nil,aux.FilterBoolFunction(Card.IsSetCard,0x30))
	--Pierce
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_EQUIP)
	e2:SetCode(EFFECT_PIERCE)
	c:RegisterEffect(e2)
	--Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(55046718,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetCondition(c55046718.thcon)
	e4:SetTarget(c55046718.thtg)
	e4:SetOperation(c55046718.thop)
	c:RegisterEffect(e4)
end
function c55046718.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPreviousPosition(POS_FACEUP)
		and e:GetHandler():IsPreviousLocation(LOCATION_ONFIELD)
end
function c55046718.thfilter(c)
	return c:IsSetCard(0x30) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function c55046718.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c55046718.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end
function c55046718.thop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,c55046718.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
	end
end
