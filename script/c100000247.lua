--賢者の石 サバティエル
function c100000247.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_DESTROYED)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetRange(LOCATION_DECK)
	e1:SetCondition(c100000247.thcon)
	e1:SetTarget(c100000247.thtg)
	e1:SetOperation(c100000247.thop)
	c:RegisterEffect(e1)
	--Activate
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetLabel(0)
	e2:SetTarget(c100000247.target)
	c:RegisterEffect(e2)
end
function c100000247.cfilter(c,tp)
	return c:IsCode(57116033) and c:GetPreviousControler()==tp
		and c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEUP)
end
function c100000247.thcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000247.cfilter,1,nil,tp)
end
function c100000247.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return e:GetHandler():IsAbleToHand() end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,e:GetHandler(),1,0,0)
end
function c100000247.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if e:GetHandler():IsRelateToEffect(e) then
		Duel.SendtoHand(c,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,c)
	end
end
function c100000247.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.PayLPCost(tp,Duel.GetLP(tp)/2)
end
function c100000247.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and chkc:IsFaceup() end
	local c=e:GetHandler()
	local ct=e:GetLabel()
	if chk==0 then 
		if ct<3 then
			return c100000247.cost(e,tp,eg,ep,ev,re,r,rp,0) 
				and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil)
		else
			return Duel.IsExistingTarget(Card.IsFaceup,tp,LOCATION_MZONE,0,1,nil)
		end
	end
	if ct<3 then
		c100000247.cost(e,tp,eg,ep,ev,re,r,rp,1)
		ct=ct+1
		e:GetHandler():SetTurnCounter(ct)
		e:SetLabel(ct)
		e:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
		e:SetProperty(0)
		Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK+LOCATION_GRAVE)
		e:SetOperation(c100000247.activate1)
	else
		e:SetCategory(CATEGORY_ATKCHANGE)
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
		Duel.SelectTarget(tp,Card.IsFaceup,tp,LOCATION_MZONE,0,1,1,nil)
		e:SetOperation(c100000247.activate2)
	end
end
function c100000247.activate1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoHand(g,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,g)
		if c:IsRelateToEffect(e) then
			c:CancelToGrave()
			Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
		end
	end
end
function c100000247.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local ct=Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		e1:SetValue(tc:GetAttack()*ct)
		tc:RegisterEffect(e1)
	end
end
