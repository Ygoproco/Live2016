--Buried Destiny
--coded by Lyris
--fixed by MLD
function c511007010.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c511007010.target)
	e1:SetOperation(c511007010.activate)
	c:RegisterEffect(e1)
	if not c511007010.globle_check then
		c511007010.globle_check=true
		c511007010[0]=Group.CreateGroup()
		c511007010[0]:KeepAlive()
		c511007010[1]=Group.CreateGroup()
		c511007010[1]:KeepAlive()
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
		ge1:SetCode(EVENT_CHAIN_SOLVED)
		ge1:SetOperation(c511007010.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c511007010.checkop(e,tp,eg,ep,ev,re,r,rp)
	if re and re:GetHandler() and re:GetHandler():IsType(TYPE_SPELL) then
		c511007010[rp]:AddCard(re:GetHandler())
	end
end
function c511007010.filter(c,tp)
	return c:IsAbleToHand() and c511007010[1-tp]:IsExists(c511007010.cfilter,1,nil,c:GetCode())
end
function c511007010.cfilter(c,code)
	return c:IsCode(code) and not c:IsLocation(LOCATION_GRAVE)
end
function c511007010.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c511007010.filter(chkc,tp) end
	if chk==0 then return Duel.IsExistingTarget(c511007010.filter,tp,LOCATION_GRAVE,0,1,nil,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c511007010.filter,tp,LOCATION_GRAVE,0,1,1,nil,tp)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c511007010.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tc)
	end
end
