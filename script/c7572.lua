--霊魂の円環
--Espirit Healing
--Scripted by Eerie Code
function c7572.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c7572.target1)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(7572,0))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_SZONE)
	e2:SetCondition(c7572.descon)
	e2:SetCost(c7572.descost)
	e2:SetTarget(c7572.destg)
	e2:SetOperation(c7572.desop)
	c:RegisterEffect(e2)
	--negate attack
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(7572,1))
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCode(EVENT_ATTACK_ANNOUNCE)
	e3:SetCondition(c7572.atkcon)
	e3:SetCost(c7572.atkcost)
	e3:SetOperation(c7572.atkop)
	c:RegisterEffect(e3)
end

function c7572.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local b1=Duel.CheckEvent(EVENT_TO_HAND) and c7572.descon(e,tp,eg,ep,ev,re,r,rp) and c7572.descost(e,tp,eg,ep,ev,re,r,rp,0) and c7572.destg(e,tp,eg,ep,ev,re,r,rp,0)
	local b2=Duel.CheckEvent(EVENT_ATTACK_ANNOUNCE) and c7572.atkcon(e,tp,eg,ep,ev,re,r,rp) and c7572.atkcost(e,tp,eg,ep,ev,re,r,rp,0)
	if (b1 or b2) and Duel.SelectYesNo(tp,94) then
		local op=0
		if b1 and b2 then
			op=Duel.SelectOption(tp,aux.Stringid(7572,0),aux.Stringid(7572,1))
		elseif b1 then
			op=Duel.SelectOption(tp,aux.Stringid(7572,0))
		else
			op=Duel.SelectOption(tp,aux.Stringid(7572,1))+1
		end
		if op==0 then
			e:SetCategory(CATEGORY_DESTROY)
			e:SetProperty(EFFECT_FLAG_CARD_TARGET)
			c7572.descost(e,tp,eg,ep,ev,re,r,rp,1)
			c7572.destg(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c7572.desop)
		else
			e:SetCategory(0)
			e:SetProperty(0)
			c7572.atkcost(e,tp,eg,ep,ev,re,r,rp,1)
			e:SetOperation(c7572.atkop)
		end
	else
		e:SetCategory(0)
		e:SetProperty(0)
		e:SetOperation(nil)
	end
end

function c7572.descfil(c,tp)
	return c:IsType(TYPE_SPIRIT) and c:IsPreviousLocation(LOCATION_MZONE) and c:IsPreviousPosition(POS_FACEUP) and c:GetPreviousControler()==tp and c:IsControler(tp)
end
function c7572.descon(e,tp,eg,ep,ev,re,r,rp)
	return eg and eg:IsExists(c7572.descfil,1,nil,tp)
end
function c7572.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,7572)==0 end
	Duel.RegisterFlagEffect(tp,7572,RESET_PHASE+PHASE_END,0,1)
end
function c7572.destg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsOnField() and chkc:IsControler(1-tp) and chkc:IsDestructable() end
	if chk==0 then return Duel.IsExistingTarget(Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsDestructable,tp,0,LOCATION_ONFIELD,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c7572.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if e:GetHandler():IsRelateToEffect(e) and tc:IsRelateToEffect(e) then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end

function c7572.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c7572.atkcfil(c)
	return c:IsType(TYPE_SPIRIT) and c:IsAbleToRemoveAsCost()
end
function c7572.atkcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,7572+1)==0 and Duel.IsExistingMatchingCard(c7572.atkcfil,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.RegisterFlagEffect(tp,7572+1,RESET_PHASE+PHASE_END,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c7572.atkcfil,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c7572.atkop(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) and Duel.NegateAttack() then
		Duel.SkipPhase(1-tp,PHASE_BATTLE,RESET_PHASE+PHASE_BATTLE,1)
	end
end
